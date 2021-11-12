//
//  RetailInfoViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "RetailInfoViewController.h"
#import "RetailInfoModel.h"
#import "RetailInfoCell.h"
#import "RetailDetailViewController.h"

#define SIZE 20

static NSString *cellID = @"infoCell";

@interface RetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;
@property(nonatomic,copy)NSString *refreshState;//是否上拉刷新

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation RetailInfoViewController
{
    UITableView *retailInfoTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"零售资讯" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    retailInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64) style:UITableViewStyleGrouped];
    retailInfoTable.rowHeight = 80;
    retailInfoTable.delegate = self;
    retailInfoTable.dataSource = self;
    retailInfoTable.sectionHeaderHeight = 5;
    retailInfoTable.sectionFooterHeight = 5;
    retailInfoTable.backgroundColor = BaseColor;
    [self.view addSubview:retailInfoTable];
    
    [retailInfoTable registerNib:[UINib nibWithNibName:@"RetailInfoCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    retailInfoTable.tableHeaderView = head;
    
    self.refreshState = @"initLoad";
    self.page = 1;
    
    [self updateData];
    //[self initData:_page];
    
#pragma mark - MJ刷新
    retailInfoTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshState = @"drop-down";//下拉状态
        self.page = 1;
        [self updateData];
    }];
    retailInfoTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.refreshState = @"pull";//上拉状态
        _page++;
        if (self.page <= _allPage) {
            [self updateData];
        }else{
            [retailInfoTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
-(void)endRefresh{
    [retailInfoTable.mj_header endRefreshing];
    [retailInfoTable.mj_footer endRefreshing];
}
- (void)updateData{
    [self initData:_page];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    retailInfoTable.mj_footer.hidden = (self.dataArr.count == 0);
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RetailInfoModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RetailDetailViewController *detail = [[RetailDetailViewController alloc]init];
    RetailInfoModel *model = _dataArr[indexPath.section];
    detail.title_ID = model.c_id;
    detail.tip = model.c_title;
    detail.date = model.c_dt;
    [detail refresh:^(BOOL isPop) {
        model.ifread = @"1";
        [retailInfoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    PushController(detail)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initData:(NSInteger)page
{
    if ([_refreshState isEqualToString:@"drop-down"]) {
        [_dataArr removeAllObjects];
        [retailInfoTable reloadData];
    }
    if ([_refreshState isEqualToString:@"initLoad"]) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }
    
    NSString *qyno = [userDefault valueForKey:@"qyno"];
    //NSString *company = [qyno substringToIndex:3];
    
    NSString *str = @"<root><api><module>1407</module><type>0</type><query>{qyno=%@,page=%d,size=%d}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,qyno,page,SIZE,[userDefault valueForKey:@"name"],UUID];
    
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
                    RetailInfoModel *model = [[RetailInfoModel alloc]init];
                    DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                    model.c_id = c_id.stringValue;
                    DDXMLElement *c_title = [item elementsForName:@"c_title"][0];
                    model.c_title = c_title.stringValue;
                    DDXMLElement *c_content = [item elementsForName:@"c_content"][0];
                    model.c_content = c_content.stringValue;
                    DDXMLElement *c_dt = [item elementsForName:@"c_dt"][0];
                    model.c_dt = c_dt.stringValue;
                    DDXMLElement *ifread = [item elementsForName:@"ifread"][0];
                    model.ifread = ifread.stringValue;
                    DDXMLElement *type = [item elementsForName:@"type"][0];
                    model.type = type.stringValue;
                    DDXMLElement *readpeonum = [item elementsForName:@"readpeonum"][0];
                    model.readpeonum = readpeonum.stringValue;
                    [self.dataArr addObject:model];
                    
                    NSArray *allpageArr = [doc nodesForXPath:@"//" error:nil];
                    for (DDXMLElement *item in allpageArr) {
                        self.allPage = [item.stringValue integerValue];
                    }
                }
                [retailInfoTable reloadData];
            }
            [self endRefresh];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    } failure:^(NSError *error) {
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
