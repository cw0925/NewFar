//
//  BindBusinessViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/1.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BindBusinessViewController.h"
#import "BusinessViewController.h"

@interface BindBusinessViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *business;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@end

@implementation BindBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"绑定企业" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
}
- (void)initUI
{
    if (_isBind) {//已绑定企业
        _business.text = _store;
        _business.userInteractionEnabled = NO;
        
        [_bindBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_bindBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{//未绑定企业
        _business.placeholder = @"请输入企业关键字";
        _business.delegate = self;
        [_bindBtn setTitle:@"申请绑定" forState:UIControlStateNormal];
        [_bindBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _phone.text = [userDefault valueForKey:@"name"];
    _phone.userInteractionEnabled = NO;
    
    _name.text = [userDefault valueForKey:@"user_name"];
    _name.userInteractionEnabled = NO;
}
//已绑定企业，确定
- (void)sureClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//未绑定企业，提交绑定企业请求
- (void)commitClick:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([_business.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择企业！"];
    }else
    {
        [self sendRequestBindBusinessData];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    BusinessViewController *business = [[BusinessViewController alloc]init];
    [business returnText:^(NSString *showText) {
        _business.text = showText;
    }];
    PushController(business)
    [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//绑定企业
- (void)sendRequestBindBusinessData
{
    NSString *business = [_business.text componentsSeparatedByString:@" "][0];
    
    NSString *str = @"<root><api><module>1405</module><type>0</type><query>{cid=%@,name=%@,jiagou=}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno><verifycode></verifycode></user></root>";
    NSString *string = [NSString stringWithFormat:str,business,_name.text,_phone.text,UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self.view makeToast:element.stringValue];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
