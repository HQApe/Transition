//
//  ViewController.m
//  HQCustomTransition
//
//  Created by zhq-t100 on 17/5/5.
//  Copyright © 2017年 Dinpay. All rights reserved.
//

#import "ViewController.h"
#import "PresenViewController.h"
#import "PopViewController.h"
#import "HQNavgationTransition.h"
#import "HQModalGesture.h"
@interface ViewController ()

@property (strong, nonatomic) HQNavgationTransition *strongReferenceDelegate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor purpleColor];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIButton *top = [UIButton buttonWithType:UIButtonTypeSystem];
    top.tag = 10;
    top.frame = CGRectMake(screenSize.width * 0.5 - 40, 100, 80, 30);
    [top setTitle:@"Top" forState:UIControlStateNormal];
    [top addTarget:self action:@selector(presentToView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:top];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeSystem];
    left.tag = 11;
    left.frame = CGRectMake(50, 200, 80, 30);
    [left setTitle:@"Left" forState:UIControlStateNormal];
    [left addTarget:self action:@selector(presentToView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeSystem];
    down.tag = 12;
    down.frame = CGRectMake(screenSize.width * 0.5 - 40, 300, 80, 30);
    [down setTitle:@"Down" forState:UIControlStateNormal];
    [down addTarget:self action:@selector(presentToView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:down];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    right.tag = 13;
    right.frame = CGRectMake(screenSize.width - 130, 200, 80, 30);
    [right setTitle:@"Right" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(presentToView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pop" style:UIBarButtonItemStylePlain target:self action:@selector(popToView:)];
    
}

- (void)presentToView:(UIButton *)button
{
    NSInteger direction = 0;
    switch (button.tag) {
        case 10:
            direction = 1;
            break;
        case 11:
            direction = 2;
            break;
        case 12:
            direction = 3;
            break;
        case 13:
            direction = 4;
            break;
        default:
            break;
    }
    
    PresenViewController *presentVc = [[PresenViewController alloc] init];
    presentVc.direction = direction;
    [self presentViewController:presentVc animated:YES completion:nil];
}

- (void)popToView:(UIBarButtonItem *)item
{
    
    
    self.strongReferenceDelegate = [[HQNavgationTransition alloc] init];
    self.navigationController.delegate = self.strongReferenceDelegate;
    
    PopViewController *popVc = [[PopViewController alloc] init];
    [self.navigationController pushViewController:popVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
