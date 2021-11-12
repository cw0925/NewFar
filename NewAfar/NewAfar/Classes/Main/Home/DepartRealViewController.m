//
//  DepartRealViewController.m
//  NewAfar
//
//  Created by cw on 16/12/16.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "DepartRealViewController.h"
#import "DepartRealModel.h"
#import "DepartRealCell.h"

#define BtnW (ViewWidth-60)/5

@interface DepartRealViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation DepartRealViewController
{
    UITableView *DepartRealTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"部门实时查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BaseColor;
    
    NSArray *arr = @[@"本日",@"昨日",@"本周",@"上周",@"本月"];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 32+20, ViewWidth, 40)];
    //head.backgroundColor = BaseColor;
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
            [self sendRequestDepartRealData:@"DD"];
        }
    }
    
    DepartRealTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(head.frame)+5, ViewWidth, ViewHeight-CGRectGetMaxY(head.frame)-5) style:UITableViewStyleGrouped];
    DepartRealTable.delegate = self;
    DepartRealTable.dataSource = self;
    DepartRealTable.sectionFooterHeight= 0;
    DepartRealTable.sectionHeaderHeight = 1;
    DepartRealTable.backgroundColor = BaseColor;
    [self.view addSubview:DepartRealTable];
    
    [DepartRealTable registerNib:[UINib nibWithNibName:@"DepartRealCell" bundle:nil] forCellReuseIdentifier:@"departRealCell"];
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
    DepartRealTable.tableHeaderView = headview;
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
    DepartRealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"departRealCell" forIndexPath:indexPath];
    if (_dataArr.count >0) {
        if (indexPath.section == 0) {
            cell.backgroundColor = CellColor;
            cell.department.text = @"部门";
            cell.sum.text = @"净收款额(万元)";
            cell.customs.text = @"顾客数(人)";
            cell.profit.text = @"毛利(万元)";
            cell.sale.text = @"促销销售(万元)";
            cell.price.text = @"客单价(元)";
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            DepartRealModel *model = _dataArr[indexPath.section - 1];
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
            [self sendRequestDepartRealData:@"DD"];
        }
            break;
        case 2:
        {
            [self sendRequestDepartRealData:@"QQ"];
        }
            break;
        case 3:
        {
            [self sendRequestDepartRealData:@"WK"];
        }
            break;
        case 4:
        {
            [self sendRequestDepartRealData:@"YY"];
        }
            break;
        case 5:
        {
            [self sendRequestDepartRealData:@"MM"];
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
- (void)sendRequestDepartRealData:(NSString *)type
{
    if (_dataArr.count>0) {
        [_dataArr removeAllObjects];
    }
    NSString *str = @"<root><api><module>0101</module><type>0</type><query>{store=%@,len=2,depart=%@,type=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    
    NSString *string = [NSString stringWithFormat:str,_store,_depart,type,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
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
                    DepartRealModel *model = [[DepartRealModel alloc]init];
                    DDXMLElement *C_adno = [item elementsForName:@"C_adno"][0];
                    model.C_adno = C_adno.stringValue;
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
                    DDXMLElement *zb = [item elementsForName:@"zb"][0];
                    model.zb = zb.stringValue;
                    [self.dataArr addObject:model];
                }
                [DepartRealTable reloadData];
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
@end
