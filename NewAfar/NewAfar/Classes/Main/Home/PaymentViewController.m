//
//  PaymentViewController.m
//  NewAfar
//
//  Created by cw on 16/12/1.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "PaymentViewController.h"
#import "PayModel.h"
#import "PayCell.h"

#define SIZE 25

@interface PaymentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation PaymentViewController
{
    UITableView *payTable;
    PayCell *head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"付款统计查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestPaymentData];
}
- (void)initUI
{
    head =[[[NSBundle mainBundle]loadNibNamed:@"PayCell" owner:self options:nil] lastObject];
    head.backgroundColor = CellColor;
    [head setFrame:CGRectMake(0,NavigationBarHeight, ViewWidth, 40)];
    [self.view addSubview:head];
    
    if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
        head.date.text = @"付款金额(万元)";
    }else{
        head.date.text = @"付款金额(元)";
    }
    
    payTable = [[UITableView alloc]initWithFrame:CGRectMake(0,NavigationBarHeight+40, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    payTable.delegate = self;
    payTable.dataSource = self;
    payTable.sectionHeaderHeight = 1;
    payTable.sectionFooterHeight = 0;
    payTable.rowHeight = 40;
    payTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    [self.view addSubview:payTable];
    [payTable registerNib:[UINib nibWithNibName:@"PayCell" bundle:nil] forCellReuseIdentifier:@"payCell"];
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
    PayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    PayModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
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
- (void)backPage
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestPaymentData
{
//    if ([_refreshState isEqualToString:@"drop-down"]) {
//        [_dataArr removeAllObjects];
//        [payTable reloadData];
//    }
//    if ([_refreshState isEqualToString:@"initLoad"]) {
//        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    }
    //<root><api><module>0904</module><type>0</type><query>{type=海龙卡,s_dt=2016-1-7,store=101,e_dt=2017-03-07}</query></api><user><company>009</company><customeruser>15603745099</customeruser><phoneno>lblblblblblbtt</phoneno></user></root>
    //<root><api><module>0904</module><type>0</type><query>{type=,s_dt=2017-3-14,store=101,cashier=,e_dt=2017-03-14,page=1,size=20}</query></api><user><company>009</company><customeruser>18300602014</customeruser><phoneno>lblblblblblbtt</phoneno></user></root>
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
     NSString *str = @"<root><api><module>0904</module><type>0</type><query>{type=%@,s_dt=%@,store=%@,cashier=%@,e_dt=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_type,_startDate,_store,_p_no,_endDate,_organization,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"string -%@,%@",string,doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                head.hidden = YES;
                [self.view makeToast:element.stringValue];
                [payTable.mj_footer setAutomaticallyHidden:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }else
            {
                head.hidden = NO;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    PayModel *model = [[PayModel alloc]init];
                    if ([item elementsForName:@"c_storeid"].count>0) {
                        DDXMLElement *c_store_id = [item elementsForName:@"c_storeid"][0];
                        model.c_store_id = c_store_id.stringValue;
                    }else{
                        model.c_store_id = @"";
                    }
                    if ([item elementsForName:@"c_storename"].count>0) {
                        DDXMLElement *c_storename = [item elementsForName:@"c_storename"][0];
                        model.c_storename = c_storename.stringValue;
                    }else{
                        model.c_storename = @"";
                    }
                    if ([item elementsForName:@"c_computer_id"].count>0) {
                        DDXMLElement *c_computer_id = [item elementsForName:@"c_computer_id"][0];
                        model.c_computer_id = c_computer_id.stringValue;
                    }else{
                        model.c_computer_id = @"";
                    }
                    if ([item elementsForName:@"c_cashier"].count>0) {
                        DDXMLElement *c_cashier = [item elementsForName:@"c_cashier"][0];
                        model.c_cashier = c_cashier.stringValue;
                    }else{
                        model.c_cashier = @"";
                    }
                    if ([item elementsForName:@"c_name"].count>0) {
                        DDXMLElement *c_name = [item elementsForName:@"c_name"][0];
                        model.c_name = c_name.stringValue;
                    }else{
                        model.c_name = @"";
                    }
                    if ([item elementsForName:@"c_amount"].count>0) {
                        DDXMLElement *c_amount = [item elementsForName:@"c_amount"][0];
                        model.c_amount = c_amount.stringValue;
                    }else{
                        model.c_amount = @"";
                    }
                    if ([item elementsForName:@"c_type"].count>0) {
                        DDXMLElement *c_type = [item elementsForName:@"c_type"][0];
                        model.c_type = c_type.stringValue;
                    }else{
                        model.c_type = @"";
                    }
                    if ([item elementsForName:@"c_zb"].count>0) {
                        DDXMLElement *c_zb = [item elementsForName:@"c_zb"][0];
                        model.c_zb = c_zb.stringValue;
                    }else{
                        model.c_zb = @"";
                    }
                    [self.dataArr addObject:model];
                }
                [payTable reloadData];
            }
            //[self endRefresh];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    } failure:^(NSError *error) {
        //[self endRefresh];
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
