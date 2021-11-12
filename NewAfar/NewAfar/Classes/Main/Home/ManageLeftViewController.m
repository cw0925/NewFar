//
//  ManageLeftViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ManageLeftViewController.h"
#import "ManageLeftCell.h"
#import "ManageSectionHeaderView.h"
#import "ManageHisModel.h"
#import "ManageLeftDataViewController.h"
#import "DatePickView.h"
#import "PickView.h"
#import "BaseNavigationController.h"


@interface ManageLeftViewController ()<ChoseClickDelegate,BtnClickDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
- (IBAction)searchClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *depart;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UITextField *responsibility;
@property (weak, nonatomic) IBOutlet UITextField *person;


@property(nonatomic,copy)NSMutableArray *departArr;
@property(nonatomic,copy)NSMutableArray *typeArr;

@end

@implementation ManageLeftViewController
{
    DatePickView *datePick;
    PickView *pick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"巡场遗留问题" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
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

    
    //默认日期
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
    }else if ([_startDate isFirstResponder]||[_endDate isFirstResponder]){
        [datePick showPickViewWhenClick:textField];
    }
    
}
- (void)btnClick:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([_depart isFirstResponder]) {
            _depart.text = pick.title.text;
        }else if ([_type isFirstResponder]){
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

- (IBAction)searchClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([_type.text isEqualToString:@""]||[_type.text isEqualToString:@"0"]) {
        _type.text = @"0";
        _type.textColor = [UIColor whiteColor];
    }else{
        _type.textColor = [UIColor blackColor];
    }

    NSArray *arr = [_depart.text componentsSeparatedByString:@" "];
    NSArray *typeArr = [_type.text componentsSeparatedByString:@" "];
    
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
//部门
- (void)sendRequestDepartData
{
    //<root><api><querytype>4</querytype><query>{store=009,sto=102}</query></api><user><company>009</company><customeruser>15939010676</customeruser></user></root>
    NSString *company = [userDefault valueForKey:@"qyno"];
    NSString *store = [userDefault valueForKey:@"store"];
    
    NSString *str = @"<root><api><querytype>4</querytype><query>{store=%@,sto=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,company,store,company,[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:LoadInfoURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
        for (DDXMLElement *element in rowArr) {
            DDXMLElement *name = [element elementsForName:@"dname"][0];
            [self.departArr addObject:name.stringValue];
        }
        
    } failure:^(NSError *error) {
        
    }];
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
@end
