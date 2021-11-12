//
//  SaleDataQueryViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/25.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "SaleDataQueryViewController.h"
#import "SaleDataViewController.h"
#import "DepartHisViewController.h"
#import "PickView.h"
#import "DatePickView.h"
#import "BaseNavigationController.h"
#import "ClassifyHisViewController.h"
#import "OrganizationRealViewController.h"
#import "DepartRealViewController.h"
#import "ClassifyRealViewController.h"

@interface SaleDataQueryViewController () <UITextFieldDelegate,BtnClickDelegate, ChoseClickDelegate>

@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UITextField *organization;
@property (weak, nonatomic) IBOutlet UITextField *department;
//@property (weak, nonatomic) IBOutlet UITextField *classify;

@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
- (IBAction)saleQueryClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *length;
//部门、分类
@property (weak, nonatomic) IBOutlet UIButton *depart_sel;
@property (weak, nonatomic) IBOutlet UIButton *classify_sel;
@property (weak, nonatomic) IBOutlet UILabel *length_name;
@property (weak, nonatomic) IBOutlet UILabel *code;

@property(nonatomic,copy)NSMutableArray *organizationArr;
@property(nonatomic,copy)NSMutableArray *departmentArr;
@property(nonatomic,copy)NSMutableArray *classifyArr;

@end

@implementation SaleDataQueryViewController
{
    PickView *pick;
    DatePickView *datePick;
    
    NSArray *organArr;
    
    NSString *type;//1-部门 2-分类
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"销售数据查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:nil];
    
    [self initUI];
    
    [self sendRequestOrganizationInfoData];
    [self sendRequestClassifyData];
}
- (void)initUI
{
    datePick = [[DatePickView alloc]initDatePickView];
    datePick.choseDelegate = self;
    
//    _length.text = @"0";
    //获取当前时间
    _startDate.text = Date;
    _endDate.text = Date;
    
    _organization.delegate = self;
    _department.delegate = self;
    //_classify.delegate = self;
    _startDate.delegate = self;
    _endDate.delegate = self;
    //部门、分类
    _depart_sel.selected = YES;
    type = @"1";
    [_depart_sel addTarget:self action:@selector(departClick:) forControlEvents:UIControlEventTouchUpInside];
    [_classify_sel addTarget:self action:@selector(classifyClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)departClick:(UIButton *)sender{
    [self.view endEditing:YES];
    sender.selected = YES;
    type = @"1";
    _classify_sel.selected = NO;
    _length_name.text = @"部门长度";
    _code.text = @"部门编码";
}
- (void)classifyClick:(UIButton *)sender{
    [self.view endEditing:YES];
    sender.selected = YES;
    type = @"2";
    _depart_sel.selected = NO;
    _length_name.text = @"分类长度";
    _code.text = @"分类编码";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_organization isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_organizationArr];
        [pick showPickViewWhenClick:_organization];
    }else if ([_startDate isFirstResponder]||[_endDate isFirstResponder]){
        [datePick showPickViewWhenClick:textField];
    }
    if ([_department isFirstResponder]){
        if (_depart_sel.selected) {
            NSLog(@"%@",_departmentArr);
            pick = [[PickView alloc]initPickViewWithArray:_departmentArr];
            [pick showPickViewWhenClick:_department];
            [self sendRequestDepartData];
        }
        if (_classify_sel.selected) {
            pick = [[PickView alloc]initPickViewWithArray:_classifyArr];
            [pick showPickViewWhenClick:_department];
        }
    }
    pick.clickDelegate = self;
}

#pragma mark - 实现点击选择器上面的取消、确定按钮的代理
- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]){
        if ([_organization isFirstResponder]) {
            _organization.text = pick.title.text;
        }
        if ([_department isFirstResponder]) {
            _department.text = pick.title.text;
            NSString *code = [_department.text componentsSeparatedByString:@" "][0];
            _length.text = [NSString stringWithFormat:@"%lu",(unsigned long)code.length];
        }
    }
     [self.view endEditing:YES];
}
#pragma mark - 日期选择器代理
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
//查询
- (IBAction)saleQueryClick:(UIButton *)sender {//按维度查询
    [self.view endEditing:YES];
    if ([_organization.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择机构！"];
    }else if ([_department.text isEqualToString:@""]){
        NSLog(@"按维度查询");
        SaleDataViewController *sale = [[SaleDataViewController alloc]init];
        NSArray *organizationArray = [_organization.text componentsSeparatedByString:@" "];
        sale.organization = organizationArray[0];
        sale.startDate = _startDate.text;
        sale.endDate = _endDate.text;
        sale.type = type;
        if ([_length.text isEqualToString:@""]) {
            sale.length = @"0";
        }else{
            sale.length = _length.text;
        }
        BaseNavigationController *BaseNvc = [[BaseNavigationController alloc]initWithRootViewController:sale];
        BaseNvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:BaseNvc animated:YES completion:^{
            
        }];

    }else if (![_department.text isEqualToString:@""]){//按部门、分类编码查询
         NSLog(@"按部门、分类编码查询");
        DepartHisViewController *departHis = [[DepartHisViewController alloc]init];
        NSArray *organizationArray = [_organization.text componentsSeparatedByString:@" "];
        departHis.store = organizationArray[0];
        
        NSArray *departArray = [_department.text componentsSeparatedByString:@" "];
        departHis.depart = departArray[0];
        if ([_length.text isEqualToString:@""]) {
            departHis.length = @"";
        }else{
            departHis.length = _length.text;
        }
        departHis.startDate = _startDate.text;
        departHis.endDate = _endDate.text;
        departHis.type = type;
        BaseNavigationController *BaseNvc = [[BaseNavigationController alloc]initWithRootViewController:departHis];
        BaseNvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:BaseNvc animated:YES completion:^{
            
        }];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//部门
- (void)sendRequestDepartData
{
    if (self.departmentArr.count>0) {
        [self.departmentArr removeAllObjects];
    }
    NSString *company = [[userDefault valueForKey:@"qyno"] substringToIndex:3];
    if (![_organization.text isEqualToString:@""]) {
        organArr = [_organization.text componentsSeparatedByString:@" "];
    }
    
    NSString *str = @"<root><api><querytype>14</querytype><query>{store=%@,sto=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    
    NSString *string = [NSString stringWithFormat:str,company,organArr[0],company,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:InfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            if ([element elementsForName:@"dname"].count>0) {
                DDXMLElement *name = [element elementsForName:@"dname"][0];
                [self.departmentArr addObject:name.stringValue];
            }
        }
        [pick reloadData];
    } failure:^(NSError *error) {
        
    }];
}
//机构
- (void)sendRequestOrganizationInfoData
{
    //<root><api><querytype>10</querytype><query>{storetype=1}</query></api><user><company>009</company><customeruser>15939010676</customeruser></user></root>
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
                
                [self sendRequestDepartData];
            }else{
                [self.view makeToast:@"请联系企业管理员！"];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//分类
- (void)sendRequestClassifyData
{
    //<root><api><module>0000</module><querytype>3</querytype></api><user><company>009105</company><customeruser>15939010676</customeruser></user></root>
    NSString *str = @"<root><api><module>0000</module><querytype>3</querytype></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:InfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    [self.classifyArr addObject:name.stringValue];
                }
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
- (NSMutableArray *)classifyArr
{
    if (!_classifyArr) {
        _classifyArr = [NSMutableArray array];
    }
    return _classifyArr;
}
- (NSMutableArray *)departmentArr
{
    if (!_departmentArr) {
        _departmentArr = [NSMutableArray array];
    }
    return _departmentArr;
}
@end
