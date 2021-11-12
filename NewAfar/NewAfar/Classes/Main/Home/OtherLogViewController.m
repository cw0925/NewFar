//
//  OtherLogViewController.m
//  NewAfar
//
//  Created by CW on 2017/4/7.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "OtherLogViewController.h"
#import "LogModel.h"
#import "WorkLogCell.h"
#import "WriteLogViewController.h"
#import "SubordinateViewController.h"

#define SIZE 10

@interface OtherLogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;

@end

@implementation OtherLogViewController
{
    UITableView *logTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:[NSString stringWithFormat:@"%@的日志",_name] hasLeft:YES hasRight:@"" withRightBarButtonItemImage:@""];
    self.page = 1;
    [self initUI];
    [self updateData];
}
- (void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    logTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64-5) style:UITableViewStylePlain];
    logTable.delegate = self;
    logTable.dataSource = self;
    [self.view addSubview:logTable];
    [logTable registerNib:[UINib nibWithNibName:@"WorkLogCell" bundle:nil] forCellReuseIdentifier:@"logCell"];
    
    UIView *foot = [[UIView alloc]init];
    logTable.tableFooterView = foot;
    
#pragma mark - MJ刷新
    logTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self updateData];
    }];
    logTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        if (self.page <= _allPage) {
            [self updateData];
        }else{
            [logTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
-(void)endRefresh{
    [logTable.mj_header endRefreshing];
    [logTable.mj_footer endRefreshing];
}
- (void)updateData{
    [self sendRequestOtherLogData:self.page];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogModel *model = _dataArr[indexPath.row];
    return [logTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[WorkLogCell class] contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubordinateViewController *log = [[SubordinateViewController alloc]init];
    log.name = _name;
    LogModel *model = _dataArr[indexPath.row];
    log.date = [model.rq componentsSeparatedByString:@" "][0];
    log.reader = model.c_no;
    log.phone = model.c_tel;
    log.newid = model.c_newid;
    PushController(log)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestOtherLogData:(NSInteger)page
{
    NSString *str = @"<root><api><module>1502</module><type>0</type><query>{reader=%@,readertel=%@,page=%d,size=%d}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_reader,_phone,page,SIZE,[userDefault valueForKey:@"name"],UUID];
    
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
                    [self.dataArr addObject:model];
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
