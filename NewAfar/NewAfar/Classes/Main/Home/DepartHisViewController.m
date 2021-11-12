//
//  DepartHisViewController.m
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "DepartHisViewController.h"
#import "DepartHisModel.h"
#import "DepartHisCell.h"

@interface DepartHisViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation DepartHisViewController
{
    UITableView *departHisTable;
    DepartHisCell *head;
    NSString *str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"销售数据查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    if ([_type isEqualToString:@"1"]) {
        [self sendRequestDepartHisData:@"0201"];
    }else{
        [self sendRequestDepartHisData:@"0203"];
    }
}
- (void)initUI
{
    head =[[[NSBundle mainBundle]loadNibNamed:@"DepartHisCell" owner:self options:nil] lastObject];
    head.backgroundColor = CellColor;
    [head setFrame:CGRectMake(0,NavigationBarHeight, ViewWidth, 40)];
    [self.view addSubview:head];
    if ([_type isEqualToString:@"1"]) {
        head.department.text = @"部门";
    }else{
        head.department.text = @"分类";
    }
    
    if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
        head.sum.text = @"净收款额(万元)";
        head.profit.text = @"毛利(万元)";
    }else{
        head.sum.text = @"净收款额(元)";
        head.profit.text = @"毛利(元)";
    }
    
    departHisTable = [[UITableView alloc]initWithFrame:CGRectMake(0,NavigationBarHeight+40, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    departHisTable.backgroundColor = BaseColor;
    departHisTable.sectionFooterHeight = 0.1;
    departHisTable.sectionHeaderHeight = 0.1;
    departHisTable.rowHeight = 40;
    departHisTable.delegate = self;
    departHisTable.dataSource = self;
    departHisTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    [self.view addSubview:departHisTable];
    [departHisTable registerNib:[UINib nibWithNibName:@"DepartHisCell" bundle:nil] forCellReuseIdentifier:@"departHisCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepartHisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"departHisCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    DepartHisModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
#pragma mark - 横屏
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
- (void)backPage
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestDepartHisData:(NSString *)module
{
    //<root><api><module>0201</module><type>0</type><query>{store=105,len=0,depart=1,s_dt=2016-2-27,e_dt=2017-02-27}</query></api><user><company>009</company><customeruser>15939010676</customeruser></user></root>
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    if ([module isEqualToString:@"0201"]) {
        str = @"<root><api><module>%@</module><type>0</type><query>{store=%@,len=%@,depart=%@,s_dt=%@,e_dt=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    }else{
        str = @"<root><api><module>%@</module><type>0</type><query>{store=%@,len=%@,ccode=%@,s_dt=%@,e_dt=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    }
    NSString *string = [NSString stringWithFormat:str,module,_store,_length,_depart,_startDate,_endDate,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                head.hidden = YES;
                [self.view makeToast:element.stringValue];
            }else{
                head.hidden = NO;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DepartHisModel *model = [[DepartHisModel alloc]init];
                    if ([item elementsForName:@"name"].count>0) {
                        DDXMLElement *name = [item elementsForName:@"name"][0];
                        model.name = name.stringValue;
                    }else{
                        model.name = @"";
                    }
                    if ([item elementsForName:@"C_adno"].count>0) {
                        DDXMLElement *adno = [item elementsForName:@"C_adno"][0];
                        model.adno = adno.stringValue;
                    }else{
                        model.adno = @"";
                    }
                    if ([item elementsForName:@"zb"].count>0) {
                        DDXMLElement *zb = [item elementsForName:@"zb"][0];
                        model.zb = zb.stringValue;
                    }else{
                        model.zb = @"";
                    }
                    if ([item elementsForName:@"amt"].count>0) {
                        DDXMLElement *amt = [item elementsForName:@"amt"][0];
                        model.amt = amt.stringValue;
                    }else{
                        model.amt = @"";
                    }
                    if ([item elementsForName:@"cxamt"].count>0) {
                        DDXMLElement *cxamt = [item elementsForName:@"cxamt"][0];
                        model.cxamt = cxamt.stringValue;
                    }else{
                        model.cxamt = @"";
                    }
                    if ([item elementsForName:@"ml"].count>0) {
                        DDXMLElement *ml = [item elementsForName:@"ml"][0];
                        model.ml = ml.stringValue;
                    }else{
                        model.ml = @"";
                    }
                    if ([item elementsForName:@"mll"].count>0) {
                        DDXMLElement *mll = [item elementsForName:@"mll"][0];
                        model.mll = mll.stringValue;
                    }else{
                        model.mll = @"";
                    }
                    if ([item elementsForName:@"customers"].count>0) {
                        DDXMLElement *customers = [item elementsForName:@"customers"][0];
                        model.customers = customers.stringValue;
                    }else{
                        model.customers = @"";
                    }
                    if ([item elementsForName:@"kdj"].count>0) {
                        DDXMLElement *kdj = [item elementsForName:@"kdj"][0];
                        model.kdj = kdj.stringValue;
                    }else{
                        model.kdj = @"";
                    }
                    [self.dataArr addObject:model];
                }
                [departHisTable reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
