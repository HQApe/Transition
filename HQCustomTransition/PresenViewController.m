//
//  PresenViewController.m
//  HQCustomTransition
//
//  Created by zhq-t100 on 17/5/5.
//  Copyright © 2017年 Dinpay. All rights reserved.
//

#import "PresenViewController.h"
#import "HQModalTransition.h"
#import "HQModalGesture.h"
@interface PresenViewController ()<UIViewControllerTransitioningDelegate>

@property (assign, nonatomic) HQModalTransitionDirectionType modalDirection;

@property (strong, nonatomic) HQModalGesture *dismissInteractive;

@end

@implementation PresenViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle =  UIModalPresentationCustom;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    containerView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:containerView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 150, 100, 30);
    
    [button setTitle:@"Dismiss" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
    
    [containerView addSubview:button];
}

- (void)dismissSelf:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setDirection:(NSInteger)direction
{
    _direction = direction;
    switch (direction) {
        case 1:
            self.modalDirection = HQModalTransitionDirectionTop;
            break;
        case 2:
            self.modalDirection = HQModalTransitionDirectionLeft;
            break;
        case 3:
            self.modalDirection = HQModalTransitionDirectionDown;
            break;
        case 4:
            self.modalDirection = HQModalTransitionDirectionRight;
            break;
            
        default:
            break;
    }
    self.dismissInteractive = [[HQModalGesture alloc] init];
    [self.dismissInteractive addModalGestureToPresentingViewController:self transitionType:HQModalTransitionPresent direction:self.modalDirection];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    //CGSizeMake(0, 300)
    //[UIScreen mainScreen].bounds.size
    return [HQModalTransition transitionWithType:HQModalTransitionPresent duration:0.25 presentOffset:60 scale:0.9 direction:self.modalDirection];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [HQModalTransition transitionWithType:HQModalTransitionDismiss duration:0.25 presentOffset:60 scale:0.9 direction:self.modalDirection];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.dismissInteractive.shouldInteracting? self.dismissInteractive : nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
