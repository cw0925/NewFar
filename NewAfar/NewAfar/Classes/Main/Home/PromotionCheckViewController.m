//
//  PromotionCheckViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/18.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "PromotionCheckViewController.h"
#import "CheckResultViewController.h"

#import "PickView.h"
#import "DatePickView.h"

@interface PromotionCheckViewController ()<BtnClickDelegate, ChoseClickDelegate>
@property (weak, nonatomic) IBOutlet UITextField *departCode;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
- (IBAction)queryClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bg_view;

@property(nonatomic,copy)NSMutableArray *departmentArr;
@end

@implementation PromotionCheckViewController
{
    PickView *pick;
    DatePickView *datePick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"促销检查" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self sendRequestDepartData];
    [self initUI];
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
//    _startDate.text = Date;
//    _endDate.text = Date;
}
- (void)editingChange:(UITextField *)sender
{
    if ([sender isEqual:_departCode]){
        pick = [[PickView alloc]initPickViewWithArray:_departmentArr];
        [pick showPickViewWhenClick:_departCode];
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
        
        if ([_departCode isFirstResponder]) {
            _departCode.text = arr[0];
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
    if ([_startDate.text isEqualToString:@""]&&[_endDate.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择日期！"];
    }else if (!([_startDate.text isEqualToString:@""]||[_endDate.text isEqualToString:@""])){
        [self.view makeToast:@"开始日期和结束日期不能同时选择！"];
    }else{
        CheckResultViewController *checkRes = [[CheckResultViewController alloc]init];
        checkRes.depart = _departCode.text;
        if (![_startDate.text isEqualToString:@""]&&[_endDate.text isEqualToString:@""]) {
            checkRes.module = @"0804";
            checkRes.sDate = _startDate.text;
        }
        if ([_startDate.text isEqualToString:@""]&&![_endDate.text isEqualToString:@""]) {
            checkRes.module = @"0805";
            checkRes.eDate = _endDate.text;
        }
        PushController(checkRes)
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//部门数据
- (void)sendRequestDepartData
{
    NSString *string = @"<root><api><querytype>4</querytype></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    [NetRequest sendRequest:InfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            DDXMLElement *name = [element elementsForName:@"name"][0];
            
            [self.departmentArr addObject:name.stringValue];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)departmentArr
{
    if (!_departmentArr) {
        _departmentArr = [NSMutableArray array];
    }
    return _departmentArr;
}

@end
