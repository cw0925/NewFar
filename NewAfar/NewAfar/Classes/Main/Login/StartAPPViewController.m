//
//  StartAPPViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/19.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "StartAPPViewController.h"
#import "LoginViewController.h"

@interface StartAPPViewController ()<UIScrollViewDelegate>

@end

@implementation StartAPPViewController
{
    UIImageView *img;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([userDefault boolForKey:@"firstLaunch"]) {
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.pagingEnabled = YES;
        scroll.contentSize = CGSizeMake(ScreenWidth*4, 0);
        scroll.delegate = self;
        [self.view addSubview:scroll];
        
        for (NSInteger i=0; i<4; i++) {
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight)];
            imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%ld.jpg",i+1]];
            [scroll addSubview:imv];
        }
    }else{
        [self loadStartPic];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [img removeFromSuperview];
            LoginViewController *login = StoryBoard(@"Login", @"login");
            [self pushViewController:login animated:YES];
        });
    }
}
- (void)loadStartPic
{
    img = [[UIImageView alloc]initWithFrame:self.view.bounds];
    img.image = [UIImage imageNamed:@"img_welcome_bg"];
    [self.view addSubview:img];
}
#pragma mark - UIScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x/ScreenWidth>3) {
        [scrollView removeFromSuperview];
        LoginViewController *login = StoryBoard(@"Login", @"login");
        [self pushViewController:login animated:YES];
    }
}
//竖屏设置
- (BOOL)shouldAutorotate
{
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
