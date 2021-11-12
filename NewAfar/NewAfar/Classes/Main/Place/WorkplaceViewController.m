//
//  WorkplaceViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "WorkplaceViewController.h"
#import "PlaceCell.h"
#import "WorkplaceModel.h"
//#import "PopView.h"
#import "CommentViewController.h"
#import "ReviewViewController.h"

#import "CarryViewController.h"

#import "WorkCell.h"

#import "LrdOutputView.h"

#define SIZE 10

@interface WorkplaceViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,LrdOutputViewDelegate>

@property(nonatomic,copy)NSMutableArray *workplaceArr;
@property(nonatomic,copy)NSMutableArray *nameArr;

@property(nonatomic,copy)NSString *refreshState;//是否上拉刷新
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;

@property(nonatomic,copy)NSString *classify;

@property (nonatomic, strong) LrdOutputView *outputView;

@end

@implementation WorkplaceViewController
{
    UITableView *placeTable;
    UITableView *popTable;
    //PopView *pop;
    NSString *qyno;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customBarWithDropDown:@"职场圈" hasLeft:NO hasRight:YES];
    [self initUI];
    
    self.refreshState = @"initLoad";
    self.page = 1;
    self.classify = @"0";
    
    [self updateData];
}
- (void)titleClick:(UIButton *)sender{
    [super titleClick:sender];
    CGFloat x = ViewWidth/2-31;
    CGFloat y = sender.frame.origin.y + sender.frame.size.height+20;
    NSLog(@"%f- %f",sender.frame.origin.y,sender.frame.size.height);
    [sender setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    LrdCellModel *all = [[LrdCellModel alloc] initWithTitle:@"全部" imageName:@"empty"];
     LrdCellModel *myFoucs = [[LrdCellModel alloc] initWithTitle:@"我关注的" imageName:@"empty"];
     LrdCellModel *my = [[LrdCellModel alloc] initWithTitle:@"我的" imageName:@"empty"];
    NSArray *titleArr = @[all,myFoucs,my];
    
    _outputView = [[LrdOutputView alloc] initWithDataArray:titleArr origin:CGPointMake(x, y) width:100 height:44 direction:kLrdOutputViewDirectionLeft];
    _outputView.delegate = self;
    _outputView.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        _outputView = nil;
        [sender setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    };
    [_outputView pop];
}
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    if (self.workplaceArr.count>0) {
        [self.workplaceArr removeAllObjects];
        [placeTable reloadData];
    }
    if (indexPath.row == 0) {
        self.classify = @"0";
    }else if (indexPath.row == 1){
        self.classify = @"1";
    }else
    {
        self.classify = @"2";
    }
    [self sendRequestWorkplaceData:_classify page:_page];
    [_outputView dismiss];
}
//发表职场圈
- (void)rightBarClick
{
    CarryViewController *carry = [[CarryViewController alloc]init];
    [carry refresh:^(BOOL isPop) {
        [placeTable.mj_header beginRefreshing];
    }];
    carry.hidesBottomBarWhenPushed = YES;
    PushController(carry)
}
- (void)initUI
{
    placeTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    placeTable.delegate = self;
    placeTable.dataSource = self;
    [self.view addSubview:placeTable];
    
    [placeTable registerNib:[UINib nibWithNibName:@"PlaceCell" bundle:nil] forCellReuseIdentifier:@"placeCell"];
    
    UIView *foot = [[UIView alloc]init];
    placeTable.tableFooterView = foot;
    
    self.classify = @"0";
#pragma mark - MJ刷新
    placeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshState = @"drop-down";//下拉状态
        self.page = 1;
        [self updateData];
    }];
    placeTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.refreshState = @"pull";//上拉状态
        _page++;
        if (self.page <= _allPage) {
            [self updateData];
        }else{
            [placeTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
-(void)endRefresh{
    [placeTable.mj_header endRefreshing];
    [placeTable.mj_footer endRefreshing];
}
- (void)updateData{
    [self sendRequestWorkplaceData:_classify page:_page];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _workplaceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkplaceModel *model = _workplaceArr[indexPath.row];
    return [placeTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[PlaceCell class] contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell" forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = _workplaceArr[indexPath.row];
    
    [cell.commentBtn addTarget:self action:@selector(buttonClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.praiseBtn addTarget:self action:@selector(buttonClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn addTarget:self action:@selector(buttonClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentViewController *comment = [[CommentViewController alloc]init];
    WorkplaceModel *model = _workplaceArr[indexPath.row];
    [comment refresh:^(NSInteger commentNum, NSInteger praiseNum) {
        model.comment = [NSString stringWithFormat:@"%ld",(long)commentNum];
        model.click = [NSString stringWithFormat:@"%ld",(long)praiseNum];
        [placeTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    comment.dataModel = model;
    comment.hidesBottomBarWhenPushed = YES;
    PushController(comment)
}
- (void)buttonClick:(UIButton *)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint Position = [touch locationInView:placeTable];
    NSIndexPath *indexPath= [placeTable indexPathForRowAtPoint:Position];
    
    if (indexPath!= nil)    {
        WorkplaceModel *model = _workplaceArr[indexPath.row];
        CommentViewController *comment = [[CommentViewController alloc]init];
        comment.dataModel = model;
        comment.hidesBottomBarWhenPushed = YES;
        PushController(comment)
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 数据源-type 全部：0 我关注的：1 我的：2
- (void)sendRequestWorkplaceData:(NSString *)type page:(NSInteger)page
{
    if ([_refreshState isEqualToString:@"drop-down"]) {
        [_workplaceArr removeAllObjects];
        [placeTable reloadData];
    }
    if ([_refreshState isEqualToString:@"initLoad"]) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }
    if ([[userDefault valueForKey:@"qyno"] isEqualToString:@""]) {
        qyno = @"";
    }else{
        qyno = [userDefault valueForKey:@"qyno"];
    }
    NSString *str = @"<root><api><module>1201</module><type>0</type><query>{type=%@,page=%d,size=%d,qyno=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,type,page,SIZE,qyno,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"doc:%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self endRefresh];
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                
                if (_workplaceArr.count>0) {
                    [_workplaceArr removeAllObjects];
                    [placeTable reloadData];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    WorkplaceModel *model = [[WorkplaceModel alloc]init];
                    DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                    model.c_id = c_id.stringValue;
                    DDXMLElement *c_newid = [item elementsForName:@"c_newid"][0];
                    model.c_newid = c_newid.stringValue;
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
                    if ([item elementsForName:@"c_position"].count>0) {
                        DDXMLElement *c_position = [item elementsForName:@"c_position"][0];
                        model.c_position = c_position.stringValue;
                    }
                    DDXMLElement *c_tel = [item elementsForName:@"c_tel"][0];
                    model.c_tel = c_tel.stringValue;
                    DDXMLElement *c_power = [item elementsForName:@"c_power"][0];
                    model.c_power = c_power.stringValue;
                    
                    DDXMLElement *tp = [item elementsForName:@"tp"][0];
                    model.tp = tp.stringValue;
                    DDXMLElement *zw = [item elementsForName:@"zw"][0];
                    model.zw = zw.stringValue;
                    DDXMLElement *click = [item elementsForName:@"click"][0];
                    model.click = click.stringValue;
                    DDXMLElement *comment = [item elementsForName:@"comment"][0];
                    model.comment = comment.stringValue;

                    [self.workplaceArr addObject:model];
                }
                NSArray *allpageArr = [doc nodesForXPath:@"//allpage" error:nil];
                for (DDXMLElement *item in allpageArr) {
                    self.allPage = [item.stringValue integerValue];
                }
                [placeTable reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
    } failure:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSMutableArray *)workplaceArr
{
    if (!_workplaceArr) {
        _workplaceArr = [NSMutableArray array];
    }
    return _workplaceArr;
}

@end
