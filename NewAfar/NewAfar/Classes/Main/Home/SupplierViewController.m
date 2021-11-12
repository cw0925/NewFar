//
//  SupplierViewController.m
//  NewAfar
//
//  Created by huanghuixiang on 16/9/5.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "SupplierViewController.h"
#import "PickView.h"
#import "DatePickView.h"
#import "SupplierResultViewController.h"

@interface SupplierViewController ()<BtnClickDelegate,ChoseClickDelegate>

@property (weak, nonatomic) IBOutlet UITextField *organization;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *classify;
@property (weak, nonatomic) IBOutlet UITextField *supplier;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
- (IBAction)queryClick:(UIButton *)sender;

@property(nonatomic,copy)NSMutableArray *supplierArr;
@property(nonatomic,copy)NSMutableArray *classifyArr;
@property(nonatomic,copy)NSMutableArray *departArr;
@property(nonatomic,copy)NSMutableArray *organizationArr;

@end

@implementation SupplierViewController
{
    PickView *pick;
    DatePickView *datePick;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"供应商销售" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    _startDate.text = Date;
    _endDate.text = Date;
    
    [self sendRequestInfoData:@"2"];
    [self sendRequestInfoData:@"3"];
    [self sendRequestInfoData:@"4"];
    [self sendRequestInfoData:@"12"];
}
- (void)initUI
{
    [_organization addTarget:self action:@selector(textfieldClick:) forControlEvents:UIControlEventEditingDidBegin];
    [_department addTarget:self action:@selector(textfieldClick:) forControlEvents:UIControlEventEditingDidBegin];
    [_classify addTarget:self action:@selector(textfieldClick:) forControlEvents:UIControlEventEditingDidBegin];
    [_supplier addTarget:self action:@selector(textfieldClick:) forControlEvents:UIControlEventEditingDidBegin];
    [_type addTarget:self action:@selector(textfieldClick:) forControlEvents:UIControlEventEditingDidBegin];
    [_startDate addTarget:self action:@selector(textfieldClick:) forControlEvents:UIControlEventEditingDidBegin];
    [_endDate addTarget:self action:@selector(textfieldClick:) forControlEvents:UIControlEventEditingDidBegin];
}
- (void)textfieldClick:(UITextField *)textfield
{
    if ([textfield isEqual:_organization]) {
        pick = [[PickView alloc]initPickViewWithArray:_organizationArr];
        [pick showPickViewWhenClick:textfield];
    }else if ([textfield isEqual:_department]){
        pick = [[PickView alloc]initPickViewWithArray:_departArr];
        [pick showPickViewWhenClick:textfield];
        
    }else if ([textfield isEqual:_classify]){
        pick = [[PickView alloc]initPickViewWithArray:_classifyArr];
        [pick showPickViewWhenClick:textfield];
        
    }else if ([textfield isEqual:_supplier]){
        pick = [[PickView alloc]initPickViewWithArray:_supplierArr];
        [pick showPickViewWhenClick:textfield];
        
    }else if ([textfield isEqual:_type]){
        pick = [[PickView alloc]initPickViewWithArray: @[@"专柜单品",@"专柜类品",@"自营单品",@"自营类品",@"租赁单品",@"租赁类品"]];
        [pick showPickViewWhenClick:textfield];
        
    }
    else
    {
        datePick = [[DatePickView alloc]initDatePickView];
        [datePick showPickViewWhenClick:textfield];
    }
    pick.clickDelegate = self;
    datePick.choseDelegate = self;
}
- (void)btnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([_organization isFirstResponder]) {
            _organization.text = [pick.title.text componentsSeparatedByString:@" "][0];
        }else if ([_department isFirstResponder]){
            _department.text = [pick.title.text componentsSeparatedByString:@" "][0];
        }else if ([_classify isFirstResponder]){
            _classify.text = [pick.title.text componentsSeparatedByString:@" "][0];
        }else if ([_supplier isFirstResponder]){
            _supplier.text = [pick.title.text componentsSeparatedByString:@" "][0];
        }else {
            _type.text = pick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (void)choseBtnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([_startDate isFirstResponder]) {
            _startDate.text = datePick.title.text;
        }else
        {
            _endDate.text = datePick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//查询
- (IBAction)queryClick:(UIButton *)sender {
    if ([_organization.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择机构代码！"];
    }else
    {
        SupplierResultViewController *res  = [[SupplierResultViewController alloc]init];
        
        res.organizationCode = _organization.text;
        res.departCode = _department.text;
        res.classifyCode = _classify.text;
        res.supplier = _supplier.text;
        res.goodType = _type.text;
        res.startDate = _startDate.text;
        res.endDate = _endDate.text;
        
        PushController(res)
    }
}
- (void)sendRequestInfoData:(NSString *)type
{
    //供应商-12，分类-3，部门-4，机构-2
    NSString *str = @"<root><api><querytype>%@</querytype></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,type];
    [NetRequest sendRequest:InfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            DDXMLElement *name = [element elementsForName:@"name"][0];
            if ([type isEqualToString:@"2"]) {
                [self.organizationArr addObject:name.stringValue];
            }else if ([type isEqualToString:@"3"]){
                [self.classifyArr addObject:name.stringValue];
            }else if ([type isEqualToString:@"4"]){
                [self.departArr addObject:name.stringValue];
            }else
            {
                [self.supplierArr addObject:name.stringValue];
            }
        }
        [self initUI];
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
- (NSMutableArray *)departArr
{
    if (!_departArr) {
        _departArr = [NSMutableArray array];
    }
    return _departArr;
}
- (NSMutableArray *)supplierArr
{
    if (!_supplierArr) {
        _supplierArr = [NSMutableArray array];
    }
    return _supplierArr;
}
@end
