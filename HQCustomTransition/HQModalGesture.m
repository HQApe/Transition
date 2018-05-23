//
//  HQModalGesture.m
//  HQCustomTransition
//
//  Created by zhq-t100 on 17/5/6.
//  Copyright © 2017年 Dinpay. All rights reserved.
//

#import "HQModalGesture.h"

@interface HQModalGesture ()

@property (strong, nonatomic) UIViewController *presentingController;

@property (nonatomic, assign) BOOL shouldFinished;

@property (nonatomic, assign) HQModalTransitionType transitionType; //!< 转场方式

@property (nonatomic, assign) HQModalTransitionDirectionType interactDirection; //!< 触发方向

@end

@implementation HQModalGesture


- (void)addModalGestureToPresentingViewController:(UIViewController *)presentingController transitionType:(HQModalTransitionType)type direction:(HQModalTransitionDirectionType)direction
{
    self.presentingController = presentingController;
    self.interactDirection = direction;
    self.transitionType = type;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [presentingController.view addGestureRecognizer:panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _shouldInteracting = YES;
            if (self.transitionType == HQModalTransitionPush) {
                CGPoint locationPoint = [panGesture locationInView:self.presentingController.view];
                switch (self.interactDirection) {
                    case HQModalTransitionDirectionTop:
                        if (locationPoint.y >= self.presentingController.view.bounds.size.height / 2.0) {
                            
                            [self.presentingController.navigationController popViewControllerAnimated:YES];
                        }
                        break;
                    case HQModalTransitionDirectionLeft:
                        if (locationPoint.x >= self.presentingController.view.bounds.size.width / 2.0) {
                            
                            [self.presentingController.navigationController popViewControllerAnimated:YES];
                        }
                        break;
                    case HQModalTransitionDirectionDown:
                        if (locationPoint.y <= self.presentingController.view.bounds.size.height / 2.0) {
                            
                            [self.presentingController.navigationController popViewControllerAnimated:YES];
                        }
                        break;
                    case HQModalTransitionDirectionRight:
                        if (locationPoint.x <= self.presentingController.view.bounds.size.width / 2.0) {
                            
                            [self.presentingController.navigationController popViewControllerAnimated:YES];
                        }
                        break;
                    default:
                        break;
                }
                
            }else if (self.transitionType == HQModalTransitionPresent) {
                [self.presentingController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat progress = 0;
            
            switch (self.interactDirection) {
                case HQModalTransitionDirectionTop:
                    progress = [panGesture translationInView:self.presentingController.view].y / self.presentingController.view.bounds.size.height;
                    self.shouldFinished = (progress < -0.5);
                    if (progress < 0) {
                        [self updateInteractiveTransition:fabs(progress)];
                    }
                    break;
                case HQModalTransitionDirectionLeft:
                    progress = [panGesture translationInView:self.presentingController.view].x / self.presentingController.view.bounds.size.width;
                    self.shouldFinished = (progress < -0.5);
                    if (progress < 0) {
                        [self updateInteractiveTransition:fabs(progress)];
                    }
                    break;
                case HQModalTransitionDirectionDown:
                    progress = [panGesture translationInView:self.presentingController.view].y / self.presentingController.view.bounds.size.height;
                    self.shouldFinished = (progress > 0.5);
                    if (progress > 0) {
                        [self updateInteractiveTransition:fabs(progress)];
                    }
                    break;
                case HQModalTransitionDirectionRight:
                    progress = [panGesture translationInView:self.presentingController.view].x / self.presentingController.view.bounds.size.width;
                    self.shouldFinished = (progress > 0.5);
                    if (progress > 0) {
                        [self updateInteractiveTransition:fabs(progress)];
                    }
                    break;
                default:
                    break;
            }
        }
            
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            _shouldInteracting = NO;
            
            if (self.shouldFinished && panGesture.state != UIGestureRecognizerStateCancelled) {
                [self finishInteractiveTransition];
            }else {
                [self updateInteractiveTransition:0];
                [self cancelInteractiveTransition];
            }
            break;
            
        default:
            break;
    }
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

@end
