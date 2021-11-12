//
//  PromotionRatioViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/17.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "PromotionRatioViewController.h"
#import "RatioResultViewController.h"

#import "PickView.h"
#import "DatePickView.h"

@interface PromotionRatioViewController ()<BtnClickDelegate, ChoseClickDelegate>
@property (weak, nonatomic) IBOutlet UIView *bg_view;
@property (weak, nonatomic) IBOutlet UITextField *organizationCode;
@property (weak, nonatomic) IBOutlet UITextField *departCode;
@property (weak, nonatomic) IBOutlet UITextField *departLen;
@property (weak, nonatomic) IBOutlet UITextField *classifyCode;
@property (weak, nonatomic) IBOutlet UITextField *classifyLen;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
- (IBAction)queryClick:(UIButton *)sender;

@property(nonatomic,copy)NSMutableArray *organizationArr;
@property(nonatomic,copy)NSMutableArray *classifyArr;
@property(nonatomic,copy)NSMutableArray *departmentArr;

@end

@implementation PromotionRatioViewController
{
    PickView *pick;
    DatePickView *datePick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"促销占比" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    [self sendRequestLengthData:@"8"];
    [self sendRequestLengthData:@"9"];
    
    [self sendRequestData:@"2"];
    [self sendRequestData:@"3"];
    [self sendRequestData:@"4"];
}
- (void)initUI
{
    for (UIView *view in _bg_view.subviews) {
        if ([view isMemberOfClass:[UITextField class]]) {
            UITextField *text = (UITextField *)view;
            [text addTarget:self action:@selector(editingChange:) forControlEvents:UIControlEventEditingDidBegin];
        }
    }
    //默认日期
    //获取当前时间
    _startDate.text = Date;
    _endDate.text = Date;
}
- (void)editingChange:(UITextField *)sender
{
    if ([sender isEqual:_organizationCode]) {
        pick = [[PickView alloc]initPickViewWithArray:_organizationArr];
        [pick showPickViewWhenClick:_organizationCode];
    }else if ([sender isEqual:_departCode]){
        pick = [[PickView alloc]initPickViewWithArray:_departmentArr];
        [pick showPickViewWhenClick:_departCode];
    }else if ([sender isEqual:_classifyCode]){
        pick = [[PickView alloc]initPickViewWithArray:_classifyArr];
        [pick showPickViewWhenClick:_classifyCode];
    }else if ([sender isEqual:_startDate]){
        //这样写pickView的代理不执行,不明白原因
        //DatePickView *datePick = [[DatePickView alloc]initDatePickView];
        
        datePick = [[DatePickView alloc]initDatePickView];
        [datePick showPickViewWhenClick:_startDate];
    }else
    {
        datePick = [[DatePickView alloc]initDatePickView];
        [datePick showPickViewWhenClick:_endDate];
    }
    
    pick.clickDelegate = self;
    datePick.choseDelegate = self;
}
#pragma mark - 实现点击选择器上面的取消、确定按钮的代理
- (void)btnClick:(UIButton *)sender
{
     NSArray *arr = [pick.title.text componentsSeparatedByString:@" "];
    if ([sender.titleLabel.text isEqualToString:@"确定"]){
        if ([_organizationCode isFirstResponder]) {
            _organizationCode.text = arr[0];
        }
        if ([_departCode isFirstResponder]) {
            _departCode.text = arr[0];
        }
        if ([_classifyCode isFirstResponder]) {
            _classifyCode.text = arr[0];
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

- (IBAction)queryClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_organizationCode.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择机构代码！"];
    }else if (![_departCode.text isEqualToString:@""]&&![_classifyCode.text isEqualToString:@""]){
        [self.view makeToast:@"部门编号和分类编号不能同时选择！"];
    }else{
        RatioResultViewController *ratio = [[RatioResultViewController alloc]init];
        ratio.organizationCode = _organizationCode.text;
        ratio.departCode = _departCode.text;
        ratio.departLen = _departLen.text;
        ratio.classifyCode = _classifyCode.text;
        ratio.classifyLen = _classifyLen.text;
        ratio.startDate = _startDate.text;
        ratio.endDate = _endDate.text;
        PushController(ratio)
    }
}
//加载机构、部门、分类
- (void)sendRequestData:(NSString *)type
{
    //2-机构、3-分类、4-部门
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
            }
            if ([type isEqualToString:@"3"]) {
                [self.classifyArr addObject:name.stringValue];
            }
            if ([type isEqualToString:@"4"]) {
                [self.departmentArr addObject:name.stringValue];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
//加载部门长度
- (void)sendRequestLengthData:(NSString *)querytype
{
    //8-部门长度 、9 - 分类长度
    NSString *str = @"<root><api><querytype>%@</querytype></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,querytype];
    [NetRequest sendRequest:InfoURL parameters:string success:^(id responseObject) {
         NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        if ([querytype isEqualToString:@"8"]) {
            NSArray *arr = [doc nodesForXPath:@"//minadnolen" error:nil];
            for (DDXMLElement *element in arr) {
                _departLen.text =  element.stringValue;
            }
        }
        else
        {
            NSArray *arr = [doc nodesForXPath:@"//mingdsclasslen" error:nil];
            for (DDXMLElement *element in arr) {
                _classifyLen.text =  element.stringValue;
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (NSMutableArray *)classifyArr
{
    if (!_classifyArr) {
        _classifyArr = [NSMutableArray array];
    }
    return _classifyArr;
}
- (NSMutableArray *)organizationArr
{
    if (!_organizationArr) {
        _organizationArr = [NSMutableArray array];
    }
    return _organizationArr;
}
- (NSMutableArray *)departmentArr
{
    if (!_departmentArr) {
        _departmentArr = [NSMutableArray array];
    }
    return _departmentArr;
}
@end
