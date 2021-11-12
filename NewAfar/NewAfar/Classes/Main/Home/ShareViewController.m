//
//  ShareViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ShareViewController.h"
#import "WorkplaceModel.h"
#import "ShareCell.h"

#define SIZE 10

@interface ShareViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;
@property(nonatomic,copy)NSString *refreshState;//是否上拉刷新

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation ShareViewController
{
    UITableView *shareTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"精彩分享" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    
    self.refreshState = @"initLoad";
    self.page = 1;

    [self sendRequestShareData:_page];
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    shareTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64) style:UITableViewStylePlain];
    shareTable.delegate = self;
    shareTable.dataSource = self;
    [self.view addSubview:shareTable];
    
    [shareTable registerClass:[ShareCell class] forCellReuseIdentifier:@"shareCell"];
    
    UIView *foot = [[UIView alloc]init];
    shareTable.tableFooterView = foot;
    
#pragma mark - MJ刷新
    shareTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshState = @"drop-down";//下拉状态
        self.page = 1;
        [self updateData];
    }];
    shareTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.refreshState = @"pull";//上拉状态
        _page++;
        if (self.page <= _allPage) {
            [self updateData];
        }else{
            [shareTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
-(void)endRefresh{
    [shareTable.mj_header endRefreshing];
    [shareTable.mj_footer endRefreshing];
}
- (void)updateView{
    [shareTable reloadData];
}
- (void)updateData{
    [self sendRequestShareData:self.page];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkplaceModel *model = _dataArr[indexPath.row];
    return [shareTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ShareCell class] contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[ShareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareCell"];
    }
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestShareData:(NSInteger)page
{
    if ([_refreshState isEqualToString:@"drop-down"]) {
        [_dataArr removeAllObjects];
        [shareTable reloadData];
    }
    if ([_refreshState isEqualToString:@"initLoad"]) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }
    
    NSString *str = @"<root><api><module>1201</module><type>0</type><query>{type=0,page=%d,size=%d}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,page,SIZE,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"doc:%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                //[self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                //无数据时显示
                self.isShowEmptyData = YES;
                self.noDataImgName = @"cb";
                
                [self.view addSubview:self.xlTableView];
                
                self.xlTableView.emptyDataSetSource = self;
                self.xlTableView.emptyDataSetDelegate = self;
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    WorkplaceModel *model = [[WorkplaceModel alloc]init];
                    DDXMLElement *tp = [item elementsForName:@"tp"][0];
                    if (![tp.stringValue isEqualToString:@"0"]) {
                        model.tp = tp.stringValue;
                        DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                        model.c_id = c_id.stringValue;
                        DDXMLElement *c_no = [item elementsForName:@"c_no"][0];
                        model.c_no = c_no.stringValue;
                        DDXMLElement *name = [item elementsForName:@"name"][0];
                        model.name = name.stringValue;
                        DDXMLElement *nr = [item elementsForName:@"nr"][0];
                        model.nr = nr.stringValue;
                        DDXMLElement *sj = [item elementsForName:@"sj"][0];
                        model.sj = sj.stringValue;
                        DDXMLElement *tx = [item elementsForName:@"tx"][0];
                        model.tx = tx.stringValue;
                        DDXMLElement *zw = [item elementsForName:@"zw"][0];
                        model.zw = zw.stringValue;
                        
                        [self.dataArr addObject:model];
                    }
                    [self updateView];
                }
                NSArray *allpageArr = [doc nodesForXPath:@"//allpage" error:nil];
                for (DDXMLElement *item in allpageArr) {
                    self.allPage = [item.stringValue integerValue];
                }
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
