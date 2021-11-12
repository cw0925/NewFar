//
//  ManagerViewController.m
//  NewAfar
//
//  Created by huanghuixiang on 16/9/5.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ManagerViewController.h"
#import "PickView.h"
#import "DatePickView.h"
#import "ManageViewViewController.h"
#import "ManagerQueryViewController.h"

@interface ManagerViewController ()<BtnClickDelegate,ChoseClickDelegate,UITextFieldDelegate>

@property(nonatomic,copy)NSMutableArray *organizationArr;
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UITextField *organization;
@property (weak, nonatomic) IBOutlet UITextField *date;
- (IBAction)queryClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *endDate;

@end

@implementation ManagerViewController
{
    PickView *pick;
    DatePickView *datePick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"店长视图" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    
    [self initUI];
    
    [self sendRequestOrganizationInfoData];
    
}
- (void)initUI
{
    _date.text = Date;
    _endDate.text = Date;
    _organization.delegate = self;
    _date.delegate = self;
    _endDate.delegate = self;
    
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
    if ([_date isFirstResponder]||[_endDate isFirstResponder]) {
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
        if ([_date isFirstResponder]) {
            _date.text = datePick.title.text;
        }else if([_endDate isFirstResponder]){
            _endDate.text = datePick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)queryClick:(UIButton *)sender {
    if ([_organization.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择机构代码！"];
    }else{
//        ManageViewViewController *manageView = [[ManageViewViewController alloc]init];
//        NSArray *arr = [_organization.text componentsSeparatedByString:@" "];
//        manageView.code = arr[0];
//        manageView.date = _date.text;
//        manageView.endDate = _endDate.text;
//        PushController(manageView)
        
        ManagerQueryViewController *manager = [[ManagerQueryViewController alloc]init];
        NSArray *arr = [_organization.text componentsSeparatedByString:@" "];
        manager.code = arr[0];
        manager.date = _date.text;
        manager.endDate = _endDate.text;
        PushController(manager)
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
