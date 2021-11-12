//
//  ReceiveLogViewController.m
//  NewAfar
//
//  Created by CW on 2017/4/11.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "ReceiveLogViewController.h"
#import "LogModel.h"
#import "WorkLogCell.h"

#define SIZE 10

@interface ReceiveLogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;
@property(nonatomic,copy)NSString *refreshState;//是否上拉刷新

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation ReceiveLogViewController
{
    UITableView *receiveTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"我收到的" hasLeft:YES hasRight:NO   withRightBarButtonItemImage:@""];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [receiveTable.mj_header beginRefreshing];
}
- (void)updateData{
    [self sendRequestReceiveData:self.page];
}
-(void)endRefresh{
    [receiveTable.mj_header endRefreshing];
    [receiveTable.mj_footer endRefreshing];
}
- (void)initUI{
    receiveTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    receiveTable.delegate = self;
    receiveTable.dataSource = self;
    [self.view addSubview:receiveTable];
    receiveTable.tableFooterView = [[UIView alloc]init];
    
    [receiveTable registerNib:[UINib nibWithNibName:@"WorkLogCell" bundle:nil] forCellReuseIdentifier:@"receiveCell"];
#pragma mark - MJ刷新
    receiveTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshState = @"drop-down";//下拉状态
        self.page = 1;
        [self updateData];
    }];
    receiveTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.refreshState = @"pull";//上拉状态
        _page++;
        if (self.page <= _allPage) {
            [self updateData];
        }else{
            [receiveTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogModel *model = _dataArr[indexPath.row];
    return [receiveTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[WorkLogCell class] contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestReceiveData:(NSInteger)page{
    if ([_refreshState isEqualToString:@"drop-down"]) {
        [_dataArr removeAllObjects];
        [receiveTable reloadData];
    }
    if ([_refreshState isEqualToString:@"initLoad"]) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }
    NSString *str = @"<root><api><module>1506</module><type>0</type><query>{page=%d,size=%d}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,page,SIZE,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self endRefresh];
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    LogModel *model = [[LogModel alloc]init];
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *zw = [item elementsForName:@"zw"][0];
                    model.zw = zw.stringValue;
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    model.nr = nr.stringValue;
                    DDXMLElement *rq = [item elementsForName:@"rq"][0];
                    model.rq = rq.stringValue;
                    DDXMLElement *tp = [item elementsForName:@"tp"][0];
                    model.tp = tp.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    model.tx = tx.stringValue;
                    [self.dataArr addObject:model];
                }
                NSArray *allpageArr = [doc nodesForXPath:@"//allpage" error:nil];
                for (DDXMLElement *item in allpageArr) {
                    self.allPage = [item.stringValue integerValue];
                }
                [receiveTable reloadData];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self endRefresh];
                [self.view makeToast:element.stringValue];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefresh];
    }];
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
