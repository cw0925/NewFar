//
//  OrganizationViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/17.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "OrganizationViewController.h"
#import "OrganizationResultViewController.h"

@interface OrganizationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *organizationCode;
@property (weak, nonatomic) IBOutlet UITextField *organizationName;
- (IBAction)queryClick:(UIButton *)sender;

@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"机构查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    //self.view.backgroundColor = BaseColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)queryClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if ([_organizationCode.text isEqualToString:@""]&&[_organizationName.text isEqualToString:@""]) {
        [self.view makeToast:@"请至少输入一个条件！"];
    }else
    {
        OrganizationResultViewController *organRes = [[OrganizationResultViewController alloc]init];
        organRes.organizationCode = _organizationCode.text;
        organRes.organizationName = _organizationName.text;
        PushController(organRes)
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
