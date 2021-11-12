//
//  ModifyPhoneViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/1.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ModifyPhoneViewController.h"
#import "LoginViewController.h"

@interface ModifyPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldnum;
@property (weak, nonatomic) IBOutlet UITextField *newnum;
- (IBAction)sureClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *confirm;

@end

@implementation ModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"修改密码" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更改密码
- (IBAction)sureClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_oldnum.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入原密码！"];
    }else if ([_newnum.text isEqualToString:@""]){
        [self.view makeToast:@"请输入新密码！"];
    }else if ([_confirm.text isEqualToString:@""]){
       [self.view makeToast:@"请确认新密码！"];
    }else if ([_newnum.text isEqualToString:@""]&&[_oldnum.text isEqualToString:@""]){
        [self.view makeToast:@"请输入原密码！"];
    }else if (![_newnum.text isEqualToString:_confirm.text]){
        [self.view makeToast:@"两次输入的密码不一致！"];
    }else
    {
        [self sendRequestModifyData];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)sendRequestModifyData
{
    NSString *str = @"<root><api><module>1401</module><type>0</type><query>{oldpsw=%@,newpsw=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_oldnum.text,_newnum.text,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"修改成功！"]) {
                LoginViewController *login = StoryBoard(@"Login", @"login")
                [login.view makeToast:@"密码修改成功，请重新登录"];
                login.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]init]];
                PushController(login)
                
            }else
            {
                [self.view makeToast:element.stringValue];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
