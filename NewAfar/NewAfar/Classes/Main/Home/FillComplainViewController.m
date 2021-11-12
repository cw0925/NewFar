//
//  FillComplainViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/12.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "FillComplainViewController.h"

@interface FillComplainViewController ()

@end

@implementation FillComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"客诉登记" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
     self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
