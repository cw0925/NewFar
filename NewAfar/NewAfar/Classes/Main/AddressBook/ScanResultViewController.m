//
//  ScanResultViewController.m
//  NewAfar
//
//  Created by cw on 17/2/16.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "ScanResultViewController.h"

@interface ScanResultViewController ()

@end

@implementation ScanResultViewController
{
    UILabel *label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"扫描结果" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI{
    label = [UILabel new];
    label.text = _res;
    label.textColor = [UIColor blueColor];
    [self.view addSubview:label];
    NSLog(@"%@",_res);
    CGFloat margin = 10;
    label.sd_layout.leftSpaceToView(self.view,margin).topSpaceToView(self.view,margin+64).rightSpaceToView(self.view,margin).autoHeightRatio(0);
    if ([label.text hasPrefix:@"http://"]||[label.text hasPrefix:@"https://"]) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureClick:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:gesture];
    }
}
- (void)gestureClick:(UITapGestureRecognizer *)gesture{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:label.text]];
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
