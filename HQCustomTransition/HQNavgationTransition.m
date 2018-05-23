//
//  HQNavgationTransition.m
//  HQCustomTransition
//
//  Created by zhq-t100 on 17/5/7.
//  Copyright © 2017年 Dinpay. All rights reserved.
//

#import "HQNavgationTransition.h"
#import "HQModalTransition.h"
#import "HQModalGesture.h"

@interface HQNavgationTransition ()

@property (strong, nonatomic) HQModalGesture *popInteractive;
@property (strong, nonatomic) UIViewController *toVC;

@end

@implementation HQNavgationTransition

- (HQModalGesture *)popInteractive
{
    if (_popInteractive == nil) {
        _popInteractive = [[HQModalGesture alloc] init];
    }
    return _popInteractive;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        [self.popInteractive addModalGestureToPresentingViewController:toVC transitionType:HQModalTransitionPush direction:HQModalTransitionDirectionRight];
        return [HQModalTransition transitionWithType:HQModalTransitionPush duration:0.25 presentOffset:0 scale:1.0 direction:HQModalTransitionDirectionRight];
        
    }
    else if (operation == UINavigationControllerOperationPop) {
        return [HQModalTransition transitionWithType:HQModalTransitionPop duration:0.25 presentOffset:0 scale:1.0 direction:HQModalTransitionDirectionTop];
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.popInteractive.shouldInteracting? self.popInteractive : nil;
}

@end
