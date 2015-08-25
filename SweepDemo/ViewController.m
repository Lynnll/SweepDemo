//
//  ViewController.m
//  SweepDemo
//
//  Created by lynnjinglei on 15/8/25.
//  Copyright (c) 2015年 XiaoLei. All rights reserved.
//

#import "ViewController.h"
#import "SweepViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:152/255.0f alpha:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIButton *sweepButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.navigationItem.title = @"扫描二维码Demo";
    sweepButton.frame = CGRectMake((self.view.frame.size.width - 200)/2, 100, 200, 30);
    [sweepButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [sweepButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:sweepButton];
    sweepButton.backgroundColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:152/255.0f alpha:1];
    [sweepButton addTarget:self action:@selector(sweepClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)sweepClick
{
    NSLog(@"sweepClick ~~~");
    SweepViewController *sweepCtrl = [[SweepViewController alloc]init];
    [self.navigationController pushViewController:sweepCtrl animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
