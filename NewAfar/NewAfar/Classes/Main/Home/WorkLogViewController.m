//
//  WorkLogViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/27.
//  Copyright © 2016年 CW. All rights reserved.
//
#import "WorkLogViewController.h"
#import "WorkLogCell.h"
#import "LogModel.h"
#import "WriteLogViewController.h"
#import "OtherLogViewController.h"
#import "ReceiveLogViewController.h"
#import "LrdOutputView.h"

#define SIZE 10

@interface WorkLogViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,LrdOutputViewDelegate>

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;
@property(nonatomic,copy)NSString *refreshState;//是否上拉刷新

@property(nonatomic,copy)NSMutableArray *logArr;

@property (nonatomic, strong) LrdOutputView *outputView;
@property (nonatomic, strong) NSMutableArray *workerArr;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation WorkLogViewController
{
    UITableView *logTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"工作日志" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
    
    self.refreshState = @"initLoad";
    self.page = 1;
    [self updateData];
    
    [self lookWorkerLogData];
}
- (void)titleClick:(UIButton *)sender{
    [super titleClick:sender];
//    if (self.dataArr.count==0) {
//        [self lookWorkerLogData];
//    }
    CGFloat x = ViewWidth/2-31;
    CGFloat y = sender.frame.origin.y + sender.frame.size.height+20;
    NSLog(@"%f- %f",sender.frame.origin.y,sender.frame.size.height);
    [sender setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    _outputView = [[LrdOutputView alloc] initWithDataArray:self.dataArr origin:CGPointMake(x, y) width:100 height:44 direction:kLrdOutputViewDirectionLeft];
    _outputView.delegate = self;
    _outputView.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        _outputView = nil;
        [sender setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    };
    [_outputView pop];
}
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    OtherLogViewController *log = [[OtherLogViewController alloc]init];
    LrdCellModel *model = self.dataArr[indexPath.row];
    log.name = model.name;
    log.reader = model.reader;
    log.phone = model.phone;
    PushController(log)
}
//写工作日志
- (void)rightBarClick
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    [self sendRequestCheckLogData:dateString phone:[userDefault valueForKey:@"name"] reader:@""];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    logTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64-5-40) style:UITableViewStylePlain];
    logTable.delegate = self;
    logTable.dataSource = self;
    [self.view addSubview:logTable];
    [logTable registerNib:[UINib nibWithNibName:@"WorkLogCell" bundle:nil] forCellReuseIdentifier:@"logCell"];
    
    UIView *foot = [[UIView alloc]init];
    logTable.tableFooterView = foot;
    
#pragma mark - MJ刷新
    logTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshState = @"drop-down";//下拉状态
        self.page = 1;
        [self updateData];
    }];
    logTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        self.refreshState = @"pull";//上拉状态
        if (self.page <= _allPage) {
            [self updateData];
        }else{
            [logTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    UIButton *bottom = [UIButton buttonWithType:UIButtonTypeCustom];
    bottom.frame = CGRectMake(0, ViewHeight-40-BottomHeight, ViewWidth,40);
    [bottom setTitle:@"我收到的日志" forState:UIControlStateNormal];
    bottom.titleLabel.font = [UIFont systemFontWithSize:14];
    [bottom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottom.backgroundColor = RGBColor(246, 246, 246);
    [bottom addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom];
}
- (void)bottomClick:(UIButton *)sender{
    ReceiveLogViewController *receive = [[ReceiveLogViewController alloc]init];
    PushController(receive)
}
-(void)endRefresh{
    [logTable.mj_header endRefreshing];
    [logTable.mj_footer endRefreshing];
}
- (void)updateData{
    [self sendRequestWorkLogData:self.page];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _logArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogModel *model = _logArr[indexPath.row];
    return [logTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[WorkLogCell class] contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _logArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WriteLogViewController *log = [[WriteLogViewController alloc]init];
    [log refresh:^(BOOL isPop) {
        [logTable.mj_header beginRefreshing];
    }];
    LogModel *model = _logArr[indexPath.row];
    log.c_newid = model.c_newid;
    log.date = [model.rq componentsSeparatedByString:@" "][0];
    
    if ([model.c_tel isEqualToString:[userDefault valueForKey:@"name"]]) {
        log.reader = @"";
        log.phone = [userDefault valueForKey:@"name"];
    }else{
        log.reader = model.c_no;
        log.phone = model.c_tel;
    }
    //当天的编辑按钮不隐藏，以前的编辑按钮隐藏
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *dateS = [formatter dateFromString:log.date];
    
    NSString *curDate = [formatter stringFromDate:[NSDate date]];
    NSDate *cur = [formatter dateFromString:curDate];
    
    NSComparisonResult result = [dateS compare:cur];
    
    NSLog(@"转换后：%@-当前：%@ ",dateS,cur);
    if (result == NSOrderedSame) {
        log.isMiss = NO;
        NSLog(@"-----1");
    }else{
        log.isMiss = YES;
        NSLog(@"-----2");
    }
    PushController(log)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//工作日志
- (void)sendRequestWorkLogData:(NSInteger)page
{
    if ([_refreshState isEqualToString:@"drop-down"]) {
        [_logArr removeAllObjects];
        [logTable reloadData];
    }
    if ([_refreshState isEqualToString:@"initLoad"]) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }
    NSString *str = @"<root><api><module>1502</module><type>0</type><query>{readno=,readertel=%@,page=%d,size=%d}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],page,SIZE,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self endRefresh];
                [self.view makeToast:element.stringValue];
                //无数据时显示
//                self.isShowEmptyData = YES;
//                self.noDataImgName = @"cb";
//                
//                [self.view addSubview:self.xlTableView];
//                
//                self.xlTableView.emptyDataSetSource = self;
//                self.xlTableView.emptyDataSetDelegate = self;
                
            }else
            {
                [self endRefresh];
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    LogModel *model = [[LogModel alloc]init];
                    DDXMLElement *c_newid = [item elementsForName:@"c_newid"][0];
                    model.c_newid = c_newid.stringValue;
                    DDXMLElement *c_no = [item elementsForName:@"c_no"][0];
                    model.c_no = c_no.stringValue;
                    DDXMLElement *c_tel = [item elementsForName:@"c_tel"][0];
                    model.c_tel = c_tel.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *zw = [item elementsForName:@"zw"][0];
                    model.zw = zw.stringValue;
                    DDXMLElement *nr = [item elementsForName:@"nr"][0];
                    model.nr = nr.stringValue;
                    DDXMLElement *rq = [item elementsForName:@"rq"][0];
                    model.rq = rq.stringValue;
                     DDXMLElement *tp = [item elementsForName:@"tp"][0];
                    if ([tp.stringValue isEqualToString:@"0"]) {
                        model.tp = @"";
                    }else{
                       model.tp = tp.stringValue; 
                    }
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    model.tx = tx.stringValue;
                    DDXMLElement *date = [item elementsForName:@"date"][0];
                    model.date = date.stringValue;
                    [self.logArr addObject:model];
                }
                NSArray *allpageArr = [doc nodesForXPath:@"//allpage" error:nil];
                for (DDXMLElement *item in allpageArr) {
                    self.allPage = [item.stringValue integerValue];
                }
                [logTable reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
        //无网络加载失败时显示
//        self.isShowEmptyData = YES;
//        self.noDataImgName = @"cb";
//        self.noDataTitle = @"网络加载失败！";
//        [self.view addSubview:self.xlTableView];
//        
//        self.xlTableView.emptyDataSetSource = self;
//        self.xlTableView.emptyDataSetDelegate = self;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//查看工作日志
- (void)sendRequestCheckLogData:(NSString *)date phone:(NSString *) phone reader:(NSString *)reader_no{
    //NSString *str = @"<root><api><module>1503</module><type>0</type><query>{time=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *str = @"<root><api><module>1503</module><type>0</type><query>{time=%@,readno=%@,readertel=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,date,reader_no,phone,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            WriteLogViewController *log = [[WriteLogViewController alloc]init];
            [log refresh:^(BOOL isPop) {
                [logTable.mj_header beginRefreshing];
            }];
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                log.isMiss = NO;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *c_newid = [item elementsForName:@"c_newid"][0];
                    log.c_newid = c_newid.stringValue;

                    DDXMLElement *rq = [item elementsForName:@"rq"][0];
                    log.date = rq.stringValue;
                }
                PushController(log)
            }else{
                //WriteLogViewController *log = [[WriteLogViewController alloc]init];
                log.isMiss = NO;
                log.date = date;
                log.c_newid = @"";
                PushController(log)
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//加载可查看人员的数据
- (void)lookWorkerLogData{
    NSString *str = @"<root><api><module>1504</module><type>0</type><query>{qyno=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>gb</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                [self customBarWithDropDown:@"工作日志" hasLeft:YES hasRight:YES];
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    DDXMLElement *c_no = [item elementsForName:@"c_no"][0];
                    DDXMLElement *c_name = [item elementsForName:@"c_name"][0];
                    DDXMLElement *c_tel = [item elementsForName:@"c_tel"][0];
                    DDXMLElement *c_tx = [item elementsForName:@"c_tx"][0];
                    LrdCellModel *model = [[LrdCellModel alloc] initWithTitle:c_name.stringValue imageName:c_tx.stringValue];
                    model.name = c_name.stringValue;
                    model.phone = c_tel.stringValue;
                    model.reader = c_no.stringValue;
                    [self.dataArr addObject:model];
                }
            }else{
                [self customNavigationBar:@"工作日志" hasLeft:YES hasRight:YES withRightBarButtonItemImage:@"edit"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)logArr
{
    if (!_logArr) {
        _logArr = [NSMutableArray array];
    }
    return _logArr;
}
- (NSMutableArray *)workerArr
{
    if (!_workerArr) {
        _workerArr = [NSMutableArray array];
    }
    return _workerArr;
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
