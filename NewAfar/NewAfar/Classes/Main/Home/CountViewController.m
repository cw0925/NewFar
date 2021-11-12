//
//  CountViewController.m
//  NewAfar
//
//  Created by cw on 17/3/9.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "CountViewController.h"
#import "DatePickView.h"
#import "RecordViewController.h"

@interface CountViewController ()<UITextFieldDelegate,ChoseClickDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;

- (IBAction)queryClick:(UIButton *)sender;

@end

@implementation CountViewController
{
    DatePickView *datePick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isManage) {
        [self customNavigationBar:@"巡场统计" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    }else{
        [self customNavigationBar:@"客诉统计" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    }
    [self initUI];
}
- (void)initUI{
    _startDate.text = Date;
    _startDate.delegate = self;
    _endDate.text = Date;
    _endDate.delegate = self;
    datePick = [[DatePickView alloc]initDatePickView];
    datePick.choseDelegate = self;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [datePick showPickViewWhenClick:textField];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)queryClick:(UIButton *)sender {
    RecordViewController *record = [[RecordViewController alloc]init];
    record.isManage = _isManage;
    record.s_date = _startDate.text;
    record.e_date = _endDate.text;
    PushController(record)
}
@end
