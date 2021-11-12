//
//  PayListViewController.m
//  NewAfar
//
//  Created by cw on 16/12/17.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "PayListViewController.h"
#import "PaymentViewController.h"
#import "PickView.h"
#import "DatePickView.h"
#import "BaseNavigationController.h"

@interface PayListViewController ()<BtnClickDelegate,UITextFieldDelegate,ChoseClickDelegate>

@property (weak, nonatomic) IBOutlet UITextField *organization;
- (IBAction)queryClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UITextField *no;

@property(nonatomic,copy)NSMutableArray *typeArr;
@property(nonatomic,copy)NSMutableArray *organizationArr;
@end

@implementation PayListViewController
{
    PickView *pick;
    DatePickView *datePick;
    NSString *payType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"付款统计" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    [self sendRequestOrganizationInfoData];
    [self sendRequestTypeData];
}
- (void)initUI{
    _organization.delegate = self;
    _type.delegate = self;
    _startDate.delegate = self;
    _endDate.delegate = self;
    
    _startDate.text = Date;
    _endDate.text = Date;
    
    datePick = [[DatePickView alloc]initDatePickView];
    datePick.choseDelegate = self;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_type isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_typeArr];
        pick.clickDelegate = self;
        [pick showPickViewWhenClick:textField];
    }else if ([_organization isFirstResponder]){
        pick = [[PickView alloc]initPickViewWithArray:_organizationArr];
        pick.clickDelegate = self;
        [pick showPickViewWhenClick:textField];
    }else{
        //datePick = [[DatePickView alloc]initDatePickView];
        [datePick showPickViewWhenClick:textField];
    }
}
- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([_type isFirstResponder]) {
            _type.text = pick.title.text;
            payType = _type.text;
        }
        if ([_organization isFirstResponder]) {
            _organization.text = pick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (void)choseBtnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([_startDate isFirstResponder]) {
            _startDate.text = datePick.title.text;
        }else{
            _endDate.text = datePick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_type isFirstResponder]) {
        payType = _type.text;
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

- (IBAction)queryClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([_type.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择付款类型！"];
    }else{
        if ([_type.text isEqualToString:@"全部"]) {
            payType = @"";
        }
        NSString *qyno = [userDefault valueForKey:@"qyno"];
        NSArray *arr = [_organization.text componentsSeparatedByString:@" "];
        
        PaymentViewController *pay = [[PaymentViewController alloc]init];
        pay.type = payType;
        pay.organization = qyno;
        pay.startDate = _startDate.text;
        pay.endDate = _endDate.text;
        pay.store = arr[0];
        if ([_no.text isEqualToString:@""]) {
            pay.p_no = @"";
        }else{
            pay.p_no = _no.text;
        }
        BaseNavigationController *BaseNvc = [[BaseNavigationController alloc]initWithRootViewController:pay];
        BaseNvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:BaseNvc animated:YES completion:^{
            
        }];
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

//付款类型
- (void)sendRequestTypeData
{
    NSString *str = @"<root><api><querytype>13</querytype><query></query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *c_type = [item elementsForName:@"c_type"][0];
                    [self.typeArr addObject:c_type.stringValue];
                }
                [self.typeArr insertObject:@"全部" atIndex:0];
                 _type.text = _typeArr[0];
                payType = _type.text;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)typeArr
{
    if (!_typeArr) {
        _typeArr = [NSMutableArray array];
    }
    return _typeArr;
}
- (NSMutableArray *)organizationArr
{
    if (!_organizationArr) {
        _organizationArr = [NSMutableArray array];
    }
    return _organizationArr;
}
@end
