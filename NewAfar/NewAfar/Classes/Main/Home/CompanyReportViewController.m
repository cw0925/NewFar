//
//  CompanyReportViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CompanyReportViewController.h"
#import "ReportCell.h"
#import "ReportModel.h"
#import "ReportDetailViewController.h"
#import "NoticeViewController.h"

#define SIZE 20

@interface CompanyReportViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;
@property(nonatomic,copy)NSString *refreshState;//是否上拉刷新

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation CompanyReportViewController
{
    UITableView *companyTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"企业公告" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    self.refreshState = @"initLoad";
    self.page = 1;
    [self updateData];
}
- (void)initUI
{
    companyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    companyTable.delegate = self;
    companyTable.dataSource = self;
    companyTable.rowHeight = 110;
    companyTable.sectionHeaderHeight = 5;
    companyTable.sectionFooterHeight = 5;
    companyTable.backgroundColor = BaseColor;
    [self.view addSubview:companyTable];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    companyTable.tableHeaderView = head;
    
    [companyTable registerNib:[UINib nibWithNibName:@"ReportCell" bundle:nil] forCellReuseIdentifier:@"reportCell"];
    
#pragma mark - MJ刷新
    companyTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshState = @"drop-down";//下拉状态
        self.page = 1;
        [self updateData];
    }];
    companyTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.refreshState = @"pull";//上拉状态
        _page++;
        if (self.page <= _allPage) {
            [self updateData];
        }else{
            [companyTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
-(void)endRefresh{
    [companyTable.mj_header endRefreshing];
    [companyTable.mj_footer endRefreshing];
}
- (void)updateData{
    [self sendRequestCompanyReportData:_page];
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
    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
    ReportModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeViewController *notice = [[NoticeViewController alloc]init];
    ReportModel *model = _dataArr[indexPath.section];
    notice.date = model.dt;
    notice.ggID = model.c_id;
    notice.heading = model.bt;
    [notice refresh:^(BOOL isPop) {
        model.ifread = @"1";
        [companyTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    PushController(notice)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 列表数据（暂无数据）
- (void)sendRequestCompanyReportData:(NSInteger)page
{
    if ([_refreshState isEqualToString:@"drop-down"]) {
        [_dataArr removeAllObjects];
        [companyTable reloadData];
    }
    if ([_refreshState isEqualToString:@"initLoad"]) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }
    
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    NSString *company = [qyno substringToIndex:3];
    //type: 0-列表 1-详情
    NSString *str = @"<root><api><module>1404</module><type>0</type><query>{cid=%@,type=0,page=%d,size=%d}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,company,page,SIZE,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                //[self.view makeToast:element.stringValue];
                //无数据时显示
                self.isShowEmptyData = YES;
                self.noDataImgName = @"cb";
                
                [self.view addSubview:self.xlTableView];
                
                self.xlTableView.emptyDataSetSource = self;
                self.xlTableView.emptyDataSetDelegate = self;
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ReportModel *model = [[ReportModel alloc]init];
                    DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                    model.c_id = c_id.stringValue;
                    DDXMLElement *bt = [item elementsForName:@"bt"][0];
                    model.bt = bt.stringValue;
                    DDXMLElement *c_type = [item elementsForName:@"c_type"][0];
                    model.c_type = c_type.stringValue;
                    DDXMLElement *dt = [item elementsForName:@"dt"][0];
                    model.dt = dt.stringValue;
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    model.nr = nr.stringValue;
                    DDXMLElement *ifread = [item elementsForName:@"ifread"][0];
                    model.ifread = ifread.stringValue;
                    DDXMLElement *readpeonum = [item elementsForName:@"readpeonum"][0];
                    model.readpeonum = readpeonum.stringValue;
                    [self.dataArr addObject:model];
                }
                NSArray *allpageArr = [doc nodesForXPath:@"//" error:nil];
                for (DDXMLElement *item in allpageArr) {
                    self.allPage = [item.stringValue integerValue];
                }
                [companyTable reloadData];
            }
            [self endRefresh];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self endRefresh];
        //无网络加载失败时显示
        self.isShowEmptyData = YES;
        self.noDataImgName = @"cb";
        self.noDataTitle = @"网络加载失败！";
        [self.view addSubview:self.xlTableView];
        
        self.xlTableView.emptyDataSetSource = self;
        self.xlTableView.emptyDataSetDelegate = self;
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
