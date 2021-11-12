//
//  FindPasswordViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/2.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "HereManager.h"

#define CountTime 60 //倒计时时间

@interface FindPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIView *bg_phone;
@property (weak, nonatomic) IBOutlet UIView *bg_new;
@property (weak, nonatomic) IBOutlet UIView *bg_sure;
@property (weak, nonatomic) IBOutlet UIView *bg_code;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *sure_pwd;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *sendCode;
- (IBAction)sureClick:(UIButton *)sender;


@end

@implementation FindPasswordViewController
{
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"忘记密码" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    //验证码倒计时时间
    [HereManager sharedManager].regiestVerifCountTime = CountTime;
}
- (void)initUI
{
    _bg_phone.layer.borderWidth = 1;
    _bg_phone.layer.borderColor = RGBColor(236, 236, 236). CGColor;
    _bg_phone.layer.cornerRadius = 5;
    _bg_phone.layer.masksToBounds = YES;
    
    _bg_new.layer.borderWidth = 1;
    _bg_new.layer.borderColor = RGBColor(236, 236, 236). CGColor;
    _bg_new.layer.cornerRadius = 5;
    _bg_new.layer.masksToBounds = YES;
    
    _bg_sure.layer.borderWidth = 1;
    _bg_sure.layer.borderColor = RGBColor(236, 236, 236). CGColor;
    _bg_sure.layer.cornerRadius = 5;
    _bg_sure.layer.masksToBounds = YES;
    
    _bg_code.layer.borderWidth = 1;
    _bg_code.layer.borderColor = RGBColor(236, 236, 236). CGColor;
    _bg_code.layer.cornerRadius = 5;
    _bg_code.layer.masksToBounds = YES;
    
    [_sendCode addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getCodeClick:(UIButton *)sender
{
    if ([_phone.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入手机号！"];
    }else if (![JudgePhone judgePhoneNumber:_phone.text]){
        [self.view makeToast:@"请输入正确的手机号！"];
    }else{
        [self sendVerifyCodeRequest];
        if (!_timer) {
            [[HereManager sharedManager] stopRegisterCountTime];
            [HereManager sharedManager].regiestVerifCountTime = CountTime;
            _sendCode.enabled = NO;
            _sendCode.titleLabel.font = [UIFont systemFontOfSize:12];
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(chageButtonCount) userInfo:nil repeats:YES];
        }
    }
}
//倒计时button时间
- (void)chageButtonCount
{
    //更新button显示时间
    _sendCode.titleLabel.font = [UIFont systemFontOfSize:12];
    NSUInteger count = [HereManager sharedManager].regiestVerifCountTime;
    [_sendCode setTitle:[NSString stringWithFormat:@"%ld s后重发",(unsigned long)count] forState:UIControlStateNormal];
    if (!count){
        [_timer invalidate];
        _timer = nil;
        _sendCode.enabled = YES;
        [_sendCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
- (IBAction)sureClick:(UIButton *)sender {
    if ([_phone.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入手机号！"];
    }else if (![JudgePhone judgePhoneNumber:_phone.text]){
        [self.view makeToast:@"请输入正确的手机号！"];
    }else if ([_pwd.text isEqualToString:@""]){
        [self.view makeToast:@"请输入新密码！"];
    }else if ([_sure_pwd.text isEqualToString:@""]){
        [self.view makeToast:@"请确认密码！"];
    }else if([_code.text isEqualToString:@""]){
        [self.view makeToast:@"请输入验证码！"];
    }else if (![_pwd.text isEqualToString:_sure_pwd.text]){
        [self.view makeToast:@"密码输入不一致！"];
    }else{
        [self sendFindPwdRequest];
    }
    [self.view endEditing:YES];
}
//验证码
- (void)sendVerifyCodeRequest
{
    NSString *string = [NSString stringWithFormat:CodeXML,_phone.text,UUID];
    
    [NetRequest sendRequest:CodeURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        //NSLog(@"code:%@",doc);
        for (DDXMLElement *element in msgArr) {
            [self.view makeToast:element.stringValue];
        }
    } failure:^(NSError *error) {
        
    }];
}
//修改密码
- (void)sendFindPwdRequest
{
    NSString *str = @"<root><api><module>1901</module><type>0</type><query>{newpwd=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno><verifycode>%@</verifycode></user></root>";
    NSString *string = [NSString stringWithFormat:str,_pwd.text,_phone.text,UUID,_code.text];
    
    [NetRequest sendRequest:FindURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"-doc:%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *item in msgArr) {
            if (![item.stringValue isEqualToString:@"密码更改成功！"]) {
                [self.view makeToast:item.stringValue];
            }else{
                [self.navigationController.viewControllers[0].view makeToast:@"密码修改成功，请重新登录！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
