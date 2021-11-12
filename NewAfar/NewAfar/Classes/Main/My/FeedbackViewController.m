//
//  FeedbackViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/1.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextView *content;
- (IBAction)commitClick:(UIButton *)sender;

@property(nonatomic,copy)NSMutableArray *resultArr;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"谏言反馈" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,80, 30)];
    title.font = [UIFont systemFontWithSize:13];
    title.text = @"  企业名称:";
    _company.leftView = title;
    _company.leftViewMode = UITextFieldViewModeAlways;
    _company.userInteractionEnabled = NO;
    _company.text = [NSString stringWithFormat:@"%@ %@",[userDefault valueForKey:@"no"],[userDefault valueForKey:@"company"]];
    _company.font = [UIFont systemFontWithSize:13];
    
    _content.layer.borderWidth = 1;
    _content.layer.borderColor = RGBColor(211, 212, 213).CGColor;
    _content.placeholder = @"您的宝贵意见，就是我们进步的源泉";
    _content.delegate = self;
    _content.font = [UIFont systemFontWithSize:13];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//提交请求
- (void)sendRequestFeedbackData
{
    NSString *str = @"<root><api><module>1402</module><type>0</type><query>{cid=%@,fyj=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"no"],_content.text,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self.view makeToast:element.stringValue];
            if ([element.stringValue isEqualToString:@"提交成功！"]) {
                [self.navigationController.viewControllers[0].view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
//提交
- (IBAction)commitClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_content.text isEqualToString:@""]) {
        [self.view makeToast:@"请填写问题的具体情况！"];
    }else{
        [self sendRequestFeedbackData];
    }
}
- (NSMutableArray *)resultArr
{
    if (!_resultArr) {
        _resultArr = [NSMutableArray array];
    }
    return _resultArr;
}
@end
