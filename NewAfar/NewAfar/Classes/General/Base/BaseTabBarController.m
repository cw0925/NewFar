//
//  BaseTabBarController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "WorkViewController.h"
#import "WorkplaceViewController.h"
#import "AddressbookViewController.h"
#import "MyViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTabBar];
}
- (void)createTabBar
{
    HomeViewController *home = StoryBoard(@"Home", @"home")
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:home];
    
    WorkViewController *work = [[WorkViewController alloc]init];
    UINavigationController *workNav = [[UINavigationController alloc]initWithRootViewController:work];
    
//    WorkplaceViewController *workplace = [[WorkplaceViewController alloc]init];
//    UINavigationController *workplaceNav = [[UINavigationController alloc]initWithRootViewController:workplace];
    
    AddressbookViewController *addressbook = [[AddressbookViewController alloc]init];
    UINavigationController *addressbookNav = [[UINavigationController alloc]initWithRootViewController:addressbook];
    
    MyViewController *my = StoryBoard(@"Home", @"my")
    UINavigationController *myNav = [[UINavigationController  alloc]initWithRootViewController:my];
//    self.viewControllers = @[homeNav,workNav,workplaceNav,addressbookNav,myNav];
    self.viewControllers = @[homeNav,workNav,addressbookNav,myNav];
//    NSArray *iconArr = @[@"home_normal",@"work_normal",@"workplace_normal",@"addressbook_normal",@"my_normal"];
    NSArray *iconArr = @[@"home_normal",@"work_normal",@"addressbook_normal",@"my_normal"];
//    NSArray *iconSelectedArr = @[@"home_selected",@"work_selected",@"workplace_selected",@"addressbook_selected",@"my_selected"];
    NSArray *iconSelectedArr = @[@"home_selected",@"work_selected",@"addressbook_selected",@"my_selected"];
//    NSArray *titleArr = @[@"首页",@"工作",@"职场圈",@"通讯录",@"我的"];
    NSArray *titleArr = @[@"首页",@"工作",@"通讯录",@"我的"];
    for (NSInteger i=0;i<iconArr.count;i++) {
        [self.tabBar.items[i] setImage:[[UIImage imageNamed:iconArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.tabBar.items[i] setSelectedImage:[[UIImage imageNamed:iconSelectedArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.tabBar.items[i] setTitle:titleArr[i]];
    }
    [self tabBarController].selectedIndex = 1;
    //点击标签时更改字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBColor(0, 162, 242),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}
// 一句话,写在UITabBarController.m脚本中,tabBar是自动执行的方法


// 点击tabbarItem自动调用
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    [self animationWithIndex:index];
    
    if([item.title isEqualToString:@"发现"])
    {
        // 也可以判断标题,然后做自己想做的事
    }
    
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    
}
//横屏设置
//- (BOOL)shouldAutorotate
//{
//    return [self.selectedViewController shouldAutorotate];
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //return [self.selectedViewController supportedInterfaceOrientations];
    return UIInterfaceOrientationMaskPortrait;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
