//
//  RealViewController.m
//  NewAfar
//
//  Created by cw on 17/1/13.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "RealViewController.h"
#import "RealDataViewController.h"
//#import "ColumnChartViewController.h"

#define BtnW (ViewWidth-30)/2

@interface RealViewController ()

@property (nonatomic ,strong)RealDataViewController *dataVC;
//@property (nonatomic ,strong)ColumnChartViewController *columnVC;
@property (nonatomic ,strong) UIViewController *currentVC;

@end

@implementation RealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"实时监测查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI
{
    self.view.backgroundColor = BaseColor;
    NSArray *arr = @[@"数据",@"图形"];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,64+10, ViewWidth, 35)];
    [self.view addSubview:headView];
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(10*(i+1)+BtnW*i, 0, BtnW, 35);
        btn.tag = i+1;
        btn.titleLabel.font = [UIFont systemFontWithSize:14];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_regist"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(showViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
        if (btn.tag == 1) {
            btn.selected = YES;
        }
    }
    
    self.dataVC = [[RealDataViewController alloc]init];
    _dataVC.code = _code;
    _dataVC.date = _date;
    [self.dataVC.view setFrame:CGRectMake(0, 74+35+10, ViewWidth, ViewHeight-84-35)];
    [self.view addSubview:self.dataVC.view];
    [self addChildViewController:self.dataVC];
    
//    self.columnVC = [[ColumnChartViewController alloc]init];
//    _columnVC.code = _code;
//    _columnVC.date = _date;
//    [self.columnVC.view setFrame:CGRectMake(0, 74+35+10, ViewWidth, ViewHeight-84-35)];
//
    self.currentVC = self.dataVC;
}
- (void)showViewClick:(UIButton *)sender{
    //处理按钮的背景切换
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+1];
        btn.selected = NO;
    }
    sender.selected = YES;
    
//    if ((self.currentVC == self.dataVC &&sender.tag == 1)||(self.currentVC == self.columnVC && sender.tag == 2)) {
//        return;
//    }else{
//        switch (sender.tag) {
//            case 1:
//            [self replaceController:self.currentVC newController:self.dataVC];
//                break;
//            case 2:
////                _columnVC.code = _code;
////                _columnVC.date = _date;
//                [self replaceController:self.currentVC newController:self.columnVC];
//                break;
//
//            default:
//                break;
//        }
//    }
}
//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:1.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            self.currentVC = oldController;
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
