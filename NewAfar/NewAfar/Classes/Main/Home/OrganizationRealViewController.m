//
//  OrganizationRealViewController.m
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "OrganizationRealViewController.h"
#import "OrganizationHisModel.h"
#import "OrganizationHisCell.h"

#define BtnW (ViewWidth-60)/5

@interface OrganizationRealViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@end

@implementation OrganizationRealViewController
{
    UITableView *organizationTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"机构实时查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BaseColor;
    
    NSArray *arr = @[@"本日",@"昨日",@"本周",@"上周",@"本月"];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 32+20, ViewWidth, 40)];
    //head.backgroundColor = [UIColor redColor];
    [self.view addSubview:head];
    
    for (NSInteger i=0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+1;
        btn.frame = CGRectMake(10*(i+1)+BtnW*i,0, BtnW, 40);
        [btn setBackgroundImage:[UIImage imageNamed:@"img_statistics_detail"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"img_statistics_detail_bg"] forState:UIControlStateSelected];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [head addSubview:btn];
        if (btn.tag == 1) {
            btn.selected = YES;
            [self sendRequestOrganizationRealData:@"DD"];
        }
    }
    
    organizationTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(head.frame)+5, ViewWidth, ViewHeight-CGRectGetMaxY(head.frame)-5) style:UITableViewStyleGrouped];
    organizationTable.delegate = self;
    organizationTable.dataSource = self;
    organizationTable.sectionFooterHeight= 0;
    organizationTable.sectionHeaderHeight = 1;
    organizationTable.backgroundColor = BaseColor;
    [self.view addSubview:organizationTable];
    
    [organizationTable registerNib:[UINib nibWithNibName:@"OrganizationHisCell" bundle:nil] forCellReuseIdentifier:@"organizationRealCell"];
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    organizationTable.tableHeaderView = headview;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArr.count>0) {
        return _dataArr.count +1;
    }else
        return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationHisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"organizationRealCell" forIndexPath:indexPath];
    if (_dataArr.count >0) {
        if (indexPath.section == 0) {
            cell.backgroundColor = CellColor;
            cell.organization.text = @"机构";
            cell.sum.text = @"净收款额(万元)";
            cell.customs.text = @"顾客数(人)";
            cell.profit.text = @"毛利(万元)";
            cell.rate.text = @"毛利率(%)";
            cell.price.text = @"客单价(元)";
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            OrganizationHisModel *model = _dataArr[indexPath.section - 1];
            [cell configCell:model];
        }
    }
    return cell;
}
//处理按钮的背景切换
- (void)btnClick:(UIButton *)sender
{
    for (NSInteger i=0; i<5; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+1];
        btn.selected = NO;
    }
    sender.selected = YES;
    switch (sender.tag) {
        case 1:
        {
            [self sendRequestOrganizationRealData:@"DD"];
        }
            break;
        case 2:
        {
            [self sendRequestOrganizationRealData:@"QQ"];
        }
            break;
        case 3:
        {
            [self sendRequestOrganizationRealData:@"WK"];
        }
            break;
        case 4:
        {
            [self sendRequestOrganizationRealData:@"YY"];
        }
            break;
        case 5:
        {
            [self sendRequestOrganizationRealData:@"MM"];
        }
            break;
            
        default:
            break;
    }
    
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
- (void)sendRequestOrganizationRealData:(NSString *)type
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    if (_dataArr.count>0) {
        [_dataArr removeAllObjects];
    }
    NSString *str = @"<root><api><module>0102</module><type>0</type><query>{store=%@,type=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_organization,type,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    //NSString *string = @"<root><api><module>0102</module><type>0</type><query>{store=001,type=QQ}</query></api><user><company>007001</company><customeruser>18703672235</customeruser></user></root>";
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                [self.view makeToast:element.stringValue];
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    OrganizationHisModel *model = [[OrganizationHisModel alloc]init];
                    DDXMLElement *c_store_id = [item elementsForName:@"c_store_id"][0];
                    model.c_store_id = c_store_id.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *amt = [item elementsForName:@"amt"][0];
                    model.amt = amt.stringValue;
                    DDXMLElement *cxamt = [item elementsForName:@"cxamt"][0];
                    model.cxamt = cxamt.stringValue;
                    DDXMLElement *ml = [item elementsForName:@"ml"][0];
                    model.ml = ml.stringValue;
                    DDXMLElement *mll = [item elementsForName:@"mll"][0];
                    model.mll = mll.stringValue;
                    DDXMLElement *customers = [item elementsForName:@"customers"][0];
                    model.customers = customers.stringValue;
                    DDXMLElement *kdj = [item elementsForName:@"kdj"][0];
                    model.kdj = kdj.stringValue;
                    [self.dataArr addObject:model];
                }
                [organizationTable reloadData];
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
