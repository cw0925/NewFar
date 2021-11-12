//
//  GoodInfoViewController.m
//  NewAfar
//
//  Created by cw on 17/3/16.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "GoodInfoViewController.h"
#import "DetailCell.h"

@interface GoodInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSArray *nameArr;

@end

@implementation GoodInfoViewController
{
    UITableView *goodTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",_model.code);
    [self customNavigationBar:_model.code hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI{
    goodTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    goodTable.delegate = self;
    goodTable.dataSource = self;
    goodTable.sectionHeaderHeight = 0;
    goodTable.sectionFooterHeight = 1;
    goodTable.backgroundColor = BaseColor;
    [self.view addSubview:goodTable];
    
    [goodTable registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    goodTable.tableHeaderView = head;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.title.text = self.nameArr[indexPath.section];
    cell.title.font = [UIFont systemFontWithSize:12];
    cell.content.font = [UIFont systemFontWithSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.content.text = _model.barcode;
    }else if(indexPath.section == 1){
        cell.content.text = [NSString stringWithFormat:@"%@ %@",_model.splb,_model.lbmc];
    }else if(indexPath.section == 2){
        cell.content.text = [NSString stringWithFormat:@"%@ %@",_model.gys,_model.gysmc];
    }else if(indexPath.section == 3){
        cell.content.text = [NSString stringWithFormat:@"%@ %@",_model.pp,_model.PPMC];
    }else if(indexPath.section == 4){
        cell.content.text = [NSString stringWithFormat:@"%@ %@",_model.bm,_model.bmmc];
    }else if(indexPath.section == 5){
        cell.content.text = [NSString stringWithFormat:@"%@ %@",_model.cd,_model.cdmc];
    }else if(indexPath.section == 6){
        cell.content.text = [NSString stringWithFormat:@"%.02f",[_model.cur_number doubleValue]];
    }else if(indexPath.section == 7){
        cell.content.text = [NSString stringWithFormat:@"%.02f",[_model.sale_number doubleValue]];
    }else if(indexPath.section == 8){
        cell.content.text = [NSString stringWithFormat:@"%.02f",[_model.cur_rec doubleValue]];
    }else if(indexPath.section == 9){
        cell.content.text = _model.last_saleday;
    }else if(indexPath.section == 10){
        cell.content.text = _model.gg;
    }else if(indexPath.section == 11){
        cell.content.text = _model.xsdw;
    }else if(indexPath.section == 12){
        cell.content.text = [NSString stringWithFormat:@"%.02f",[_model.lsj doubleValue]];
    }else if(indexPath.section == 13){
        cell.content.text = [NSString stringWithFormat:@"%.02f",[_model.hyj doubleValue]];
    }else if(indexPath.section == 14){
        cell.content.text = [NSString stringWithFormat:@"%.02f",[_model.zkj doubleValue]];
    }else if(indexPath.section == 15){
        cell.content.text = [NSString stringWithFormat:@"%.02f",[_model.pfj doubleValue]];
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray *)nameArr
{
    if (!_nameArr) {
        _nameArr = @[@"主条码",@"商品类别",@"主供应商",@"品牌信息",@"所属部门",@"产地",@"当期库存",@"当日销售",@"当日进货量",@"最后销售日期",@"规格",@"销售单位",@"零售价",@"会员价",@"折扣价",@"批发价"];
    }
    return _nameArr;
}
@end
