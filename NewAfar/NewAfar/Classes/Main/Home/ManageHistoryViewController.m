//
//  ManageHistoryViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/5.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ManageHistoryViewController.h"
#import "ManageSectionHeaderView.h"
#import "ManageHisModel.h"
#import "ManageHisCell.h"
#import "DatePickView.h"
#import "PickView.h"
#import "ManageHistoryDataViewController.h"
#import "BaseNavigationController.h"
#import "ManageLeftDataViewController.h"

@interface ManageHistoryViewController ()<ChoseClickDelegate,UITextFieldDelegate,BtnClickDelegate>
- (IBAction)seachClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *depart;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UITextField *responsibility;
@property (weak, nonatomic) IBOutlet UITextField *person;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UITextField *state;

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *departArr;
@property(nonatomic,copy)NSMutableArray *typeArr;
@property(nonatomic,copy)NSArray *stateArr;

@end

@implementation ManageHistoryViewController
{
    DatePickView *datePick;
    PickView *pick;
    NSString *statue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"巡场记录" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    [self sendRequestDepartData];
    [self sendRequestInfoData:@"5"];
}
- (void)initUI
{

    _depart.delegate = self;
    
    _type.delegate = self;
    
    _startDate.delegate = self;
    
    _endDate.delegate = self;
    
    _state.delegate = self;
    
    //默认处理状态
    statue = @"2";
    //获取当前时间
    _startDate.text = Date;
    _endDate.text = Date;
    
    datePick = [[DatePickView alloc]initDatePickView];
    datePick.choseDelegate = self;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_depart isFirstResponder]) {
        pick = [[PickView alloc]initPickViewWithArray:_departArr];
        pick.clickDelegate = self;
        [pick showPickViewWhenClick:textField];
    }else if ([_type isFirstResponder]){
        pick = [[PickView alloc]initPickViewWithArray:_typeArr];
        pick.clickDelegate = self;
        [pick showPickViewWhenClick:textField];
    }else if ([_state isFirstResponder]){
        pick = [[PickView alloc]initPickViewWithArray:self.stateArr];
        pick.clickDelegate = self;
        [pick showPickViewWhenClick:textField];
    }else if ([_startDate isFirstResponder]||[_endDate isFirstResponder]){
        [datePick showPickViewWhenClick:textField];
        datePick.choseDelegate = self;
    }
    
}
- (void)btnClick:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([_depart isFirstResponder]) {
            _depart.text = pick.title.text;
        }else if ([_type isFirstResponder]){
            _type.text = pick.title.text;
        }else if ([_state isFirstResponder]){
            _state.text = pick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (void)choseBtnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([_startDate isFirstResponder]) {
            _startDate.text = datePick.title.text;
        }
        if ([_endDate isFirstResponder]) {
            _endDate.text = datePick.title.text;
        }
    }
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//按条件搜索[@"全部",@"已处理",@"未处理",@"逾期未处理"];后边加了type表示状态  1是已处理  0是未处理  2是全部
- (IBAction)seachClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    NSArray *arr = [_depart.text componentsSeparatedByString:@" "];
    NSArray *typeArr = [_type.text componentsSeparatedByString:@" "];
    
    if ([_type.text isEqualToString:@""]||[_type.text isEqualToString:@"0"]) {
        _type.text = @"0";
        _type.textColor = [UIColor whiteColor];
    }else{
        _type.textColor = [UIColor blackColor];
    }
    if ([_state.text isEqualToString:@"逾期未处理"]) {
        ManageLeftDataViewController *data = [[ManageLeftDataViewController alloc]init];
        data.depart = arr[0];
        data.type = typeArr[0];
        data.resP = _responsibility.text;
        data.manP = _person.text;
        data.startD = _startDate.text;
        data.endD = _endDate.text;
        BaseNavigationController *BaseNvc = [[BaseNavigationController alloc]initWithRootViewController:data];
        BaseNvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:BaseNvc animated:YES completion:^{
            
        }];
    }else{
        if ([_state.text isEqualToString:@"全部"]) {
            statue = @"2";
        }else if ([_state.text isEqualToString:@"已处理"]){
            statue = @"1";
        }else if ([_state.text isEqualToString:@"未处理"]){
            statue = @"0";
        }
        ManageHistoryDataViewController *data = [[ManageHistoryDataViewController alloc]init];
        data.depart = arr[0];
        data.type = typeArr[0];
        data.resP = _responsibility.text;
        data.manP = _person.text;
        data.startD = _startDate.text;
        data.endD = _endDate.text;
        data.state = statue;
        BaseNavigationController *BaseNvc = [[BaseNavigationController alloc]initWithRootViewController:data];
        [self presentViewController:BaseNvc animated:YES completion:^{
            
        }];
    }
}
// 5 - 巡场类型
- (void)sendRequestInfoData:(NSString *)querytype
{
    NSString *company = [userDefault valueForKey:@"qyno"];
    
    NSString *str = @"<root><api><querytype>%@</querytype><query>{store=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,querytype,company,company,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                if ([querytype isEqualToString:@"5"]) {
                    for (DDXMLElement *item in rowArr) {
                        DDXMLElement *tid = [item elementsForName:@"tid"][0];
                        DDXMLElement *tname = [item elementsForName:@"tname"][0];
                        [self.typeArr addObject:[NSString stringWithFormat:@"%@ %@",tid.stringValue,tname.stringValue]];
                    }
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//4-部门
- (void)sendRequestDepartData
{
    //<root><api><querytype>4</querytype><query>{store=009,sto=102}</query></api><user><company>009</company><customeruser>15939010676</customeruser></user></root>
    NSString *company = [userDefault valueForKey:@"qyno"];
    NSString *store = [userDefault valueForKey:@"store"];
    
    NSString *str = @"<root><api><querytype>14</querytype><query>{store=%@,sto=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,company,store,company,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:InfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            if ([element elementsForName:@"dname"].count>0) {
                DDXMLElement *name = [element elementsForName:@"dname"][0];
                [self.departArr addObject:name.stringValue];
            }
        }

    } failure:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)departArr
{
    if (!_departArr) {
        _departArr = [NSMutableArray array];
    }
    return _departArr;
}
- (NSMutableArray *)typeArr
{
    if (!_typeArr) {
        _typeArr = [NSMutableArray array];
    }
    return _typeArr;
}
- (NSArray *)stateArr
{
    if (!_stateArr) {
        _stateArr = @[@"全部",@"已处理",@"未处理",@"逾期未处理"];
    }
    return _stateArr;
}
@end
