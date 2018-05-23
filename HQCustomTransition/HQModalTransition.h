//
//  HQModalTransition.h
//  HQCustomTransition
//
//  Created by zhq-t100 on 17/5/5.
//  Copyright © 2017年 Dinpay. All rights reserved.
//

/**
 UINavigationController 和 UITabBarController 这两个容器 VC 的根视图在屏幕上是不可见的(或者说是透明的)，可见的只是内嵌在这两者中的子 VC 中的视图，转场是从子 VC 的视图转换到另外一个子 VC 的视图，其根视图并未参与转场；而 Modal 转场，以 presentation 为例，是从 presentingView 转换到 presentedView，根视图 presentingView 也就是 fromView 参与了转场。而且 NavigationController 和 TabBarController 转场中的 containerView 也并非这两者的根视图。
 Modal 转场与两种容器 VC 的转场的另外一个不同是：Modal 转场结束后 presentingView 可能依然可见，UIModalPresentationPageSheet 模式就是这样。这种不同导致了 Modal 转场和容器 VC 的转场对 fromView 的处理差异：容器 VC 的转场结束后 fromView 会被主动移出视图结构，这是可预见的结果，我们也可以在转场结束前手动移除；而 Modal 转场中，presentation 结束后 presentingView(fromView) 并未主动被从视图结构中移除。准确来说，是 UIModalPresentationCustom 这种模式下的 Modal 转场结束时 fromView 并未从视图结构中移除；UIModalPresentationFullScreen 模式的 Modal 转场结束后 fromView 依然主动被从视图结构中移除了。这种差异导致在处理 dismissal 转场的时候很容易出现问题，没有意识到这个不同点的话出错时就会毫无头绪。下面来看看 dismissal 转场时的场景。
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HQModalTransition : NSObject<UIViewControllerAnimatedTransitioning>

typedef NS_ENUM(NSUInteger, HQModalTransitionType) {
    HQModalTransitionPresent = 1,
    HQModalTransitionDismiss,
    HQModalTransitionPush,
    HQModalTransitionPop
};

typedef NS_ENUM(NSUInteger, HQModalTransitionDirectionType) {
    HQModalTransitionDirectionTop = 1,
    HQModalTransitionDirectionLeft,
    HQModalTransitionDirectionDown,
    HQModalTransitionDirectionRight
};

/*
 *  指定动画类型
 *
 *  @param type            动画类型
 *  @param duration        动画时长
 *  @param presentOffset   弹出视图呈现的偏移量
 *  @param scale           fromVC的绽放系数
 *  @param direction       弹出的方向
 *
 *  @return HQModalTransition
 */
+ (HQModalTransition *)transitionWithType:(HQModalTransitionType)type
                                  duration:(NSTimeInterval)duration
                             presentOffset:(CGFloat)presentOffset
                                     scale:(CGFloat)scale
                                direction:(HQModalTransitionDirectionType)direction;

@end
