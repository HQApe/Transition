//
//  HQModalGesture.h
//  HQCustomTransition
//
//  Created by zhq-t100 on 17/5/6.
//  Copyright © 2017年 Dinpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HQModalTransition.h"

@interface HQModalGesture : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign, readonly) BOOL shouldInteracting; //!< 是否允许触发交互


/**
 给转场添加手势

 @param presentingController 转场控制器
 @param type 转场方式
 @param direction 触发方向
 */
- (void)addModalGestureToPresentingViewController:(UIViewController *)presentingController transitionType:(HQModalTransitionType)type direction:(HQModalTransitionDirectionType)direction;

@end
