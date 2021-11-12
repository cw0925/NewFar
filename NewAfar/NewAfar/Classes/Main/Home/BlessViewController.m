//
//  BlessViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/2.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BlessViewController.h"

@interface BlessViewController ()<UITextViewDelegate>

@end

@implementation BlessViewController
{
    UITextView *text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"祝福" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
}
- (void)blessClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self sendRequestBlessData];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    text = [[UITextView alloc]initWithFrame:CGRectMake(10,64+10, ViewWidth-20, 150)];
    text.layer.borderWidth = 1;
    text.layer.borderColor = RGBColor(211, 212, 213).CGColor;
    text.text = @"祝你生日快乐！";
    text.delegate = self;
    [self.view addSubview:text];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(10, 64+10+150+10, ViewWidth-20, 35);
    [sure setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [sure setTitle:@"祝福" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(blessClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"祝你生日快乐！";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"祝你生日快乐！"]){
        textView.text = @"";
        textView.textColor=[UIColor blackColor];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestBlessData
{
    NSString *str = @"<root><api><module>1305</module><type>0</type><query>{name=%@,content=%@,title=生日祝福,alias=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_name,text.text,_phone,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"成功！"]) {
                [self.navigationController.viewControllers[1].view makeToast:@"发送成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
             [self.view makeToast:element.stringValue];   
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    NSLog(@"------------");
}
@end
