//
//  HQModalTransition.m
//  HQCustomTransition
//
//  Created by zhq-t100 on 17/5/5.
//  Copyright © 2017年 Dinpay. All rights reserved.
//


#import "HQModalTransition.h"

@interface HQModalTransition ()

@property (nonatomic, assign) HQModalTransitionType type;
@property (nonatomic, assign) HQModalTransitionDirectionType directionType;
@property (nonatomic, assign) CGFloat presentOffset;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation HQModalTransition

+ (HQModalTransition *)transitionWithType:(HQModalTransitionType)type duration:(NSTimeInterval)duration presentOffset:(CGFloat)presentOffset scale:(CGFloat)scale direction:(HQModalTransitionDirectionType)direction
{
    HQModalTransition *transition = [[HQModalTransition alloc] init];
    transition.type = type;
    transition.presentOffset = presentOffset;
    transition.scale = scale;
    transition.duration = duration;
    transition.directionType = direction;
    return transition;
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animationEnded:(BOOL)transitionCompleted
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.type) {
        case HQModalTransitionPresent: {
            [self present:transitionContext];
            break;
        }
        case HQModalTransitionDismiss: {
            [self dismiss:transitionContext];
            break;
        }
        case HQModalTransitionPush: {
            [self push:transitionContext];
            break;
        }
        case HQModalTransitionPop: {
            [self pop:transitionContext];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Private
- (void)present:(id<UIViewControllerContextTransitioning>)transitonContext {
    //通过viewForKey:获取的视图是viewControllerForKey:返回的控制器的根视图，或者 nil。viewForKey:方法返回 nil 只有一种情况：UIModalPresentationCustom 模式下的Modal转场 ，通过此方法获取 presentingView 时得到的将是 nil，这时通过viewForKey:方法来获取 presentingView 得到的是 nil，必须通过viewControllerForKey:得到 presentingVC 后来获取。因此在 Modal 转场中，较稳妥的方法是从 fromVC 和 toVC 中获取 fromView 和 toView。
    UIView *fromView = [transitonContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitonContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *containerView = [transitonContext containerView];
    containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];//背景色
    
    // 要实现转场，必须加入到containerView中
    [containerView addSubview:toView];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;  //屏幕的大小
    // 我们要设置外部所传参数
    // 设置弹出的方向
    switch (self.directionType) {
        case HQModalTransitionDirectionTop:
            toView.frame = CGRectMake(0,
                                         -screenSize.height,
                                         containerView.frame.size.width,
                                         screenSize.height - self.presentOffset);
            break;
        case HQModalTransitionDirectionLeft:
            toView.frame = CGRectMake(-screenSize.width,
                                         0,
                                         screenSize.width - self.presentOffset,
                                         containerView.frame.size.height);
            break;
        case HQModalTransitionDirectionDown:
            toView.frame = CGRectMake(0,
                                         screenSize.height,
                                         containerView.frame.size.width,
                                         screenSize.height - self.presentOffset);
            break;
        case HQModalTransitionDirectionRight:
            toView.frame = CGRectMake(containerView.frame.size.width,
                                         0,
                                         screenSize.width - self.presentOffset,
                                         containerView.frame.size.height);
            break;
            
        default:
            break;
    }
    
    // 开始动画
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        // 设置弹出的距离
        switch (self.directionType) {
            case HQModalTransitionDirectionTop:
                toView.transform = CGAffineTransformMakeTranslation(0, screenSize.height - self.presentOffset);
                break;
            case HQModalTransitionDirectionLeft:
                toView.transform = CGAffineTransformMakeTranslation(screenSize.width - self.presentOffset, 0);
                break;
            case HQModalTransitionDirectionDown:
                toView.transform = CGAffineTransformMakeTranslation(0, -(screenSize.height - self.presentOffset));
                break;
            case HQModalTransitionDirectionRight:
                toView.transform = CGAffineTransformMakeTranslation(-(screenSize.width - self.presentOffset), 0);
                break;
                
            default:
                break;
        }
        //背景色透明度
        containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        // 让源控制器的View放缩
        fromView.transform = CGAffineTransformMakeScale(weakSelf.scale, weakSelf.scale);
    } completion:^(BOOL finished) {
        if (finished) {
            BOOL isCanceled = [transitonContext transitionWasCancelled];
            [transitonContext completeTransition:!isCanceled];
        }else {
            [transitonContext completeTransition:NO];
        }
    }];
}

- (void)dismiss:(id<UIViewControllerContextTransitioning>)transitonContext {
    //逆向过程，fromView和toView跟present的对调
    UIView *fromView = [transitonContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitonContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *containerView = [transitonContext containerView];
    
    // 开始动画
    [UIView animateWithDuration:self.duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0]; //背景色透明度
        toView.transform = CGAffineTransformIdentity;
        fromView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        BOOL isCanceled = [transitonContext transitionWasCancelled];
        [transitonContext completeTransition:!isCanceled];
        if (isCanceled) {
            
            [UIView animateWithDuration:0.25 animations:^{
                toView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
            }];
        }
    }];
}

- (void)push:(id<UIViewControllerContextTransitioning>)transitonContext
{
    [self present:transitonContext];
}

- (void)pop:(id<UIViewControllerContextTransitioning>)transitonContext
{
    UIView *fromView = [transitonContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitonContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *containerView = [transitonContext containerView];
    containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];//背景色
    
    // 要实现转场，必须加入到containerView中
    [containerView addSubview:toView];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;  //屏幕的大小
    // 我们要设置外部所传参数
    // 设置弹出的方向
    switch (self.directionType) {
        case HQModalTransitionDirectionTop:
            toView.frame = CGRectMake(0,
                                      screenSize.height,
                                      containerView.frame.size.width,
                                      screenSize.height - self.presentOffset);
            break;
        case HQModalTransitionDirectionLeft:
            toView.frame = CGRectMake(screenSize.width,
                                      0,
                                      screenSize.width - self.presentOffset,
                                      containerView.frame.size.height);
            break;
        case HQModalTransitionDirectionDown:
            toView.frame = CGRectMake(0,
                                      -screenSize.height,
                                      containerView.frame.size.width,
                                      screenSize.height - self.presentOffset);
            break;
        case HQModalTransitionDirectionRight:
            toView.frame = CGRectMake(-screenSize.width,
                                      0,
                                      screenSize.width - self.presentOffset,
                                      containerView.frame.size.height);
            break;
            
        default:
            break;
    }
    
    // 开始动画
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        // 设置弹出的距离
        switch (self.directionType) {
            case HQModalTransitionDirectionTop:
                toView.transform = CGAffineTransformMakeTranslation(0, -(screenSize.height - self.presentOffset));
                break;
            case HQModalTransitionDirectionLeft:
                toView.transform = CGAffineTransformMakeTranslation(-(screenSize.width - self.presentOffset), 0);
                break;
            case HQModalTransitionDirectionDown:
                toView.transform = CGAffineTransformMakeTranslation(0, (screenSize.height - self.presentOffset));
                break;
            case HQModalTransitionDirectionRight:
                toView.transform = CGAffineTransformMakeTranslation((screenSize.width - self.presentOffset), 0);
                break;
                
            default:
                break;
        }
        //背景色透明度
        containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        // 让源控制器的View放缩
        fromView.transform = CGAffineTransformMakeScale(weakSelf.scale, weakSelf.scale);
    } completion:^(BOOL finished) {
        if (finished) {
            BOOL isCanceled = [transitonContext transitionWasCancelled];
            [transitonContext completeTransition:!isCanceled];
        }else {
            [transitonContext completeTransition:NO];
        }
    }];
}

@end
