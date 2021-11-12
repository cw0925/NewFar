//
//  OrganizationDetailViewController.m
//  NewAfar
//
//  Created by cw on 16/12/16.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "OrganizationDetailViewController.h"

@interface OrganizationDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *storeID;
@property (weak, nonatomic) IBOutlet UILabel *person;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UIView *bg;

@end

@implementation OrganizationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"机构详情" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
}
- (void)initUI
{
    _bg.layer.borderWidth = 1;
    _bg.layer.borderColor = RGBColor(151, 151, 151).CGColor;
    
    _tip.text = _model.c_name;
    _name.text = _model.c_name;
    _address.text = _model.dz;
    _code.text = _model.psjg;
    _storeID.text = _model.c_id;
    _person.text = _model.fzr;
    _tel.text = _model.tel;
    _category.text = _model.lb;
    _time.text = _model.pszq;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
