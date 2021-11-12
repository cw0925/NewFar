//
//  RealMonitorViewController.m
//  NewFarSoft
//
//  Created by huanghuixiang on 16/9/1.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "RealMonitorViewController.h"
#import "PickView.h"
#import "DatePickView.h"
#import "MonitorModel.h"
#import "RealControlCell.h"
#import "RealViewController.h"

#import "RealTimeViewController.h"

@interface RealMonitorViewController ()<BtnClickDelegate,ChoseClickDelegate,UITextFieldDelegate>

- (IBAction)queryClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *organization;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *length;

@property(nonatomic,copy)NSMutableArray *organizationArr;

@end

@implementation RealMonitorViewController
{
    PickView *pick;
    DatePickView *datePick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavigationBar:@"实时监测" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self sendRequestOrganizationInfoData];
    [self initUI];
}
- (void)initUI
{
    //_length.text = @"0";
    _date.text = Date;
    _organization.delegate = self;
    _date.delegate = self;
    
    datePick = [[DatePickView alloc]initDatePickView];
    datePick.choseDelegate = self;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_organization isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_organizationArr];
        pick.clickDelegate = self;
        [pick showPickViewWhenClick:textField];
    }
    if ([_date isFirstResponder]) {
        [datePick showPickViewWhenClick:textField];
    }
}
- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        _organization.text = pick.title.text;
    }
    [self.view endEditing:YES];
}
- (void)choseBtnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        _date.text = datePick.title.text;
    }
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)queryClick:(UIButton *)sender{
    if ([_organization.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入机构代码！"];
    }else{
        RealTimeViewController *real = [[RealTimeViewController alloc]init];
         NSArray *arr = [_organization.text componentsSeparatedByString:@" "];
        real.code = arr[0];
        real.date = _date.text;
        if ([self.length.text isEqualToString:@""]) {
            real.length = @"0";
        }else{
            real.length = self.length.text;
        }
        PushController(real)
    }
}

//机构
- (void)sendRequestOrganizationInfoData
{
    NSString *str = @"<root><api><querytype>10</querytype><query>{storetype=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *company = [[userDefault valueForKey:@"qyno"] substringToIndex:3];
    
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"storetype"],company,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    NSArray *arr = [name.stringValue componentsSeparatedByString:@","];
                    [self.organizationArr addObjectsFromArray:arr];
                }
                _organization.text = _organizationArr[0];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)organizationArr
{
    if (!_organizationArr) {
        _organizationArr = [NSMutableArray array];
    }
    return _organizationArr;
}
@end
