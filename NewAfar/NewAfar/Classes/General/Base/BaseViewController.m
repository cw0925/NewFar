//
//  BaseViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/19.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BaseViewController.h"
#import "UIButton+LXMImagePosition.h"

@interface BaseViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}
//自定义导航条（不带下拉文字菜单）
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    self.navigationItem.title = title;
    if (isLeft) {
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        //        left.backgroundColor = [UIColor redColor];
        left.frame = CGRectMake(0, 0, 60, 20);
        left.titleLabel.font = [UIFont systemFontOfSize:16];
        [left setImage:[UIImage imageNamed:@"fanhui"] forState: UIControlStateNormal];
        [left setTitle:@"返回" forState:UIControlStateNormal];
        [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [left addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
        [left setImagePosition:LXMImagePositionLeft spacing:-15];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spacer.width = -15;
        
        if (@available(iOS 11.0, *)) {
            left.contentEdgeInsets =UIEdgeInsetsMake(0, -7,0, 0);
            left.imageEdgeInsets =UIEdgeInsetsMake(0, -10,0, 0);
            self.navigationItem.leftBarButtonItems=@[leftBarButtonItem];
        }else{
            self.navigationItem.leftBarButtonItems=@[spacer,leftBarButtonItem];
        }
        
    }
    if (isRight) {
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
        right.frame = CGRectMake(0, 0, 20, 20);
        right.center = barView.center;
        [right setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [right addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:right];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
    }
    
}
//自定义导航条（带下拉文字菜单）
- (void)customBarWithDropDown:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight
{
    /* 中间的标题按钮 */
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 100, 30);
    // 设置图片和文字
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    //上、左、下、右
    if (title.length == 3) {
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0,-60, 0, 0);
    }
    else
    {
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0,-70, 0, 0);
    }
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
    
    if (isLeft) {
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        //        left.backgroundColor = [UIColor redColor];
        left.frame = CGRectMake(0, 0, 60, 20);
        left.titleLabel.font = [UIFont systemFontOfSize:16];
        [left setImage:[UIImage imageNamed:@"fanhui"] forState: UIControlStateNormal];
        [left setTitle:@"返回" forState:UIControlStateNormal];
        [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [left addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
        [left setImagePosition:LXMImagePositionLeft spacing:-15];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spacer.width = -15;
        
        if (@available(iOS 11.0, *)) {
            left.contentEdgeInsets =UIEdgeInsetsMake(0, -7,0, 0);
            left.imageEdgeInsets =UIEdgeInsetsMake(0, -10,0, 0);
            self.navigationItem.leftBarButtonItems=@[leftBarButtonItem];
        }else{
            self.navigationItem.leftBarButtonItems=@[spacer,leftBarButtonItem];
        }
    }
    
    if (isRight) {
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
        right.frame = CGRectMake(0, 0, 20, 20);
        right.center = barView.center;
        [right setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [right addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:right];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
    }
}
//返回按钮
- (void)backPage
{
    [self.view endEditing:YES];
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count > 1)
    {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self)
        {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//中间按钮
- (void)titleClick:(UIButton *)sender
{
}
//右侧按钮
- (void)rightBarClick
{
    NSLog(@"-------");
}

//#pragma mark - 横竖屏设置
//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}
#pragma mark - 无数据显示页
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.noDataImgName) {
        return [UIImage imageNamed:self.noDataImgName];
    }
    return [UIImage imageNamed:@"NoData"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = self.noDataTitle?self.noDataTitle:@"暂无任何数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor grayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = self.noDataDetailTitle;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return self.noDataDetailTitle?[[NSAttributedString alloc] initWithString:text attributes:attributes]:nil;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.isShowEmptyData;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -self.xlTableView.tableHeaderView.frame.size.height/2.0f;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]};
    
    return self.btnTitle?[[NSAttributedString alloc] initWithString:self.btnTitle attributes:attributes]:nil;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return self.btnImgName?[UIImage imageNamed:self.btnImgName]:nil;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self buttonEvent];
}

#pragma mark 按钮事件
-(void)buttonEvent
{
    
}

-(UITableView *)xlTableView
{
    if(_xlTableView == nil)
    {
        _xlTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NVHeight, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
        _xlTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        _xlTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        
        _xlTableView.showsVerticalScrollIndicator = NO;
        _xlTableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _xlTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
