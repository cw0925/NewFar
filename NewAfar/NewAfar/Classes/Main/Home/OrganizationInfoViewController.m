//
//  OrganizationInfoViewController.m
//  NewAfar
//
//  Created by cw on 17/3/17.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "OrganizationInfoViewController.h"
#import "DetailCell.h"

@interface OrganizationInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSArray *dataArr;

@end

@implementation OrganizationInfoViewController
{
    UITableView *organizationTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:_model.c_name hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
}
- (void)initUI{
    organizationTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    organizationTable.delegate = self;
    organizationTable.dataSource = self;
    organizationTable.sectionHeaderHeight = 0;
    organizationTable.sectionFooterHeight = 1;
    organizationTable.backgroundColor = BaseColor;
    organizationTable.scrollEnabled = NO;
    [self.view addSubview:organizationTable];
    
    [organizationTable registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    organizationTable.tableHeaderView = head;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.title.text = self.dataArr[indexPath.section];
    cell.title.font = [UIFont systemFontWithSize:12];
    cell.content.font = [UIFont systemFontWithSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.content.text = _model.dz;
    }else if(indexPath.section == 1){
        cell.content.text = _model.psjg;
    }else if(indexPath.section == 2){
        cell.content.text = _model.c_id;
    }else if(indexPath.section == 3){
        cell.content.text = _model.fzr;
    }else if(indexPath.section == 4){
        cell.content.text = _model.tel;
    }else if(indexPath.section == 5){
        cell.content.text = _model.lb;
    }else if(indexPath.section == 6){
        cell.content.text = _model.pszq;
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@"详细地址",@"配送机构代码",@"门店编号",@"负责人",@"电话",@"类别",@"配送周期"];
    }
    return _dataArr;
}
@end
