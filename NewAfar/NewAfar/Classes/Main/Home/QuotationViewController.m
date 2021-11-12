//
//  QuotationViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "QuotationViewController.h"
#import "PickView.h"

@interface QuotationViewController ()<UITextViewDelegate,UITextFieldDelegate,BtnClickDelegate>

@property (weak, nonatomic) IBOutlet UITextField *theme;
@property (weak, nonatomic) IBOutlet UITextField *classify;
@property (weak, nonatomic) IBOutlet UITextView *opinion;
- (IBAction)submitClick:(UIButton *)sender;

@end

@implementation QuotationViewController
{
    UILabel *label;
    PickView *pick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"意见反馈" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
}
- (void)initUI
{
    _theme.font = [UIFont systemFontWithSize:13];

    _classify.font = [UIFont systemFontWithSize:13];
    _classify.delegate = self;
    
    _opinion.layer.borderWidth = 1;
    _opinion.layer.borderColor = RGBColor(211, 212, 213).CGColor;
    _opinion.font = [UIFont systemFontWithSize:13];
    _opinion.delegate = self;
    _opinion.placeholder = @"您的宝贵意见，就是我们进步的源泉";
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_classify isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:@[@"意见",@"建议",@"投诉"]];
        pick.clickDelegate = self;
        [pick showPickViewWhenClick:textField];
    }
}
- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([_classify isFirstResponder]) {
            _classify.text = pick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if ([_theme.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入主题"];
    }else if ([_opinion.text isEqualToString:@""]){
        [self.view makeToast:@"请输入你的宝贵意见"];
    }else if ([_classify.text isEqualToString:@""]){
        [self.view makeToast:@"请输入分类"];
    }else
    {
        [self sendRequestCommitData];
    }
}
- (void)sendRequestCommitData
{
    NSString *str = @"<root><api><module>1406</module><type>0</type><query>{topic=%@,kinds=%@,content=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_theme.text,_classify.text,_opinion.text,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"提交成功！"]) {
                [self.navigationController.viewControllers[1].view makeToast:element.stringValue];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:element.stringValue];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
