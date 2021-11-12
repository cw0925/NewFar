//
//  CustomerServiceViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import <WebKit/WebKit.h>

@interface CustomerServiceViewController ()

@end

@implementation CustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"商翼客服" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUI];
}
- (void)initUI
{
    WKWebView *web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64)];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ServiceURL]]];
    [self.view addSubview:web];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
