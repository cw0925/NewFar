//
//  SaleDataViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/25.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "SaleDataViewController.h"
#import "OrganizationHisCell.h"
#import "OrganizationHisModel.h"

@interface SaleDataViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation SaleDataViewController
{
    UITableView *dataTable;
    //UIView *head;
    OrganizationHisCell *head;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"销售数据查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestData:_type];
    NSLog(@"单位：%@",[userDefault valueForKey:@"unit"]);
}
- (void)initUI
{
    head = [[[NSBundle mainBundle]loadNibNamed:@"OrganizationHisCell" owner:self options:nil] lastObject];
    head.backgroundColor = CellColor;
    head.frame = CGRectMake(0,NavigationBarHeight, ScreenWidth, 40);
    [self.view addSubview:head];
    if ([_type isEqualToString:@"1"]) {
        head.organization.text = @"部门";
    }else{
        head.organization.text = @"分类";
    }
    if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
        head.sum.text = @"净收款额(万元)";
        head.profit.text = @"毛利(万元)";
    }else{
        head.sum.text = @"净收款额(元)";
        head.profit.text = @"毛利(元)";
    }
    dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0,NavigationBarHeight+40, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.sectionFooterHeight = 0.1;
    dataTable.sectionHeaderHeight = 0.1;
    dataTable.rowHeight = 40;
    dataTable.backgroundColor = BaseColor;
    dataTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    [self.view addSubview:dataTable];
    [dataTable registerNib:[UINib nibWithNibName:@"OrganizationHisCell" bundle:nil] forCellReuseIdentifier:@"ohCell"];
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
    OrganizationHisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ohCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    OrganizationHisModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
- (void)backPage
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 横屏
//- (BOOL)shouldAutorotate {
//    return YES;
//}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeRight;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//机构历史
- (void)sendRequestData:(NSString *)state
{
    //<root><api><module>0202</module><type>0</type><query>{store=101,len=0,type=1,s_dt=2017-04-20,e_dt=2017-04-20}</query></api><user><company>009</company><customeruser>18300602014</customeruser></user></root>部门
    //<root><api><module>0202</module><type>0</type><query>{store=101,len=0,type=2,s_dt=2017-04-20,e_dt=2017-04-20}</query></api><user><company>009</company><customeruser>18300602014</customeruser></user></root>分类
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>0202</module><type>0</type><query>{store=%@,len=%@,type=%@,s_dt=%@,e_dt=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_organization,_length,state,_startDate,_endDate,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                head.hidden = YES;
                [self.view makeToast:element.stringValue];
            }else
            {
                head.hidden = NO;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    OrganizationHisModel *model = [[OrganizationHisModel alloc]init];
                    if ([item elementsForName:@"C_adno"].count>0) {
                        DDXMLElement *C_adno = [item elementsForName:@"C_adno"][0];
                        model.C_adno = C_adno.stringValue;
                    }
                    if ([item elementsForName:@"c_ccode"].count>0) {
                        DDXMLElement *C_adno = [item elementsForName:@"c_ccode"][0];
                        model.C_adno = C_adno.stringValue;
                    }
                    if ([item elementsForName:@"name"].count>0) {
                        DDXMLElement *name = [item elementsForName:@"name"][0];
                        model.name = name.stringValue;
                    }else{
                        model.name = @"";
                    }
                    if ([item elementsForName:@"storeid"].count>0) {
                        DDXMLElement *storeid = [item elementsForName:@"storeid"][0];
                        model.storeid = storeid.stringValue;
                    }else{
                        model.storeid = @"";
                    }
                    if ([item elementsForName:@"storename"].count>0) {
                        DDXMLElement *storename = [item elementsForName:@"storename"][0];
                        model.storename = storename.stringValue;
                    }else{
                        model.storename = @"";
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
            }
            [dataTable reloadData];
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
