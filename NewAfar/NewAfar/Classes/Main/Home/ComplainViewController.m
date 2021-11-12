//
//  ComplainViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/25.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ComplainViewController.h"
#import "ComplainCell.h"
#import "FillComplainViewController.h"
#import "ComplainModel.h"
#import "ComplainDetailViewController.h"

#import "RegistComplainViewController.h"

#import "DOPDropDownMenu.h"
#import "MJRefresh.h"

#import "ClassificationModel.h"
#import "CompensateModel.h"
#import "CountViewController.h"

#define TabbarHeight 48
#define SIZE 10

@interface ComplainViewController ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITextViewDelegate>

@property (nonatomic, weak) DOPDropDownMenu *menu;
@property(nonatomic,copy)NSMutableArray *dataArr;

@property(nonatomic,copy)NSString *organization_row;
@property(nonatomic,copy)NSString *measure_row;
@property(nonatomic,copy)NSString *type_row;
@property(nonatomic,copy)NSString *statue_row;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger allPage;
@property(nonatomic,copy)NSString *refreshState;//是否上拉刷新

@end

@implementation ComplainViewController
{
    UITableView *complainTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customNavigationBar:@"客诉处理" hasLeft:YES hasRight:YES withRightBarButtonItemImage:@"edit"];
    
    [self initTopView];
    [self createMainView];
    
    self.refreshState = @"initLoad";
    self.page = 1;
    
    [self sendRequestComplainData:_page];
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:isLeft hasRight:isRight withRightBarButtonItemImage:image];
    if (isRight) {
        UIButton *count = [UIButton buttonWithType:UIButtonTypeCustom];
        count.frame = CGRectMake(0, 0, 40, 30);
        count.titleLabel.font = [UIFont systemFontWithSize:14];
        [count setTitle:@"统计" forState:UIControlStateNormal];
        [count setTitleColor:RGBColor(18,184,246) forState:UIControlStateNormal];
        [count addTarget:self action:@selector(countClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *count_item = [[UIBarButtonItem alloc]initWithCustomView:count];
        
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
        edit.frame = CGRectMake(0, 0, 20, 20);
        edit.center = barView.center;
        [edit setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [edit addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:edit];
        UIBarButtonItem *edit_item = [[UIBarButtonItem alloc]initWithCustomView:barView];
        NSArray *items = [NSArray array];
        if ([userDefault boolForKey:@"kswrite"]) {
            items = @[edit_item,count_item];
        }else{
            items = @[count_item];
        }
        self.navigationItem.rightBarButtonItems = items;
    }
}
- (void)countClick:(UIButton *)sender{
    CountViewController *count = StoryBoard(@"Home", @"count")
    count.isManage = NO;
    PushController(count)
}
//客诉登记
- (void)rightBarClick
{
    if ([userDefault boolForKey:@"kswrite"]) {
        RegistComplainViewController *regist = [[RegistComplainViewController alloc]init];
        //添加数据的刷新
        [regist refresh:^(BOOL isPop) {
            NSLog(isPop?@"返回YES刷新":@"返回NO不刷新");
            [complainTable.mj_header beginRefreshing];
        }];
        PushController(regist)
    }else{
        [self.view makeToast:@"您尚未获得添加客诉的权限"];
    }
}
- (void)initTopView
{
    _organization_row = @"";
    _measure_row = @"";
    _type_row = @"";
    _statue_row = @"";
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, NVHeight) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    _menu = menu;
    
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    //[menu selectDefalutIndexPath];
}
//分栏数目
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 4;
}
//每个栏目的行数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return _data1.count;
    }else if (column == 1){
        return _data2.count;
    }else if(column == 2){
        return _data3.count;
    }else
    {
        return _data4.count;
    }
}
//每个栏目的每行的内容
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return _data1[indexPath.row];
    } else if (indexPath.column == 1){
        ClassificationModel *model = _data2[indexPath.row];
        return model.tname;
    } else  if(indexPath.column == 2){
        CompensateModel *model = _data3[indexPath.row];
        return model.tname;
    }else{
        return _data4[indexPath.row];
    }
}
//展示列点击事件
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        if (indexPath.column == 0) {
            if (indexPath.row ==0) {
                _organization_row = @"";
            }else{
                NSArray *arr = [_data1[indexPath.row] componentsSeparatedByString:@" "];
                _organization_row = arr[0];
            }
        }else if (indexPath.column == 1){
            if (indexPath.row == 0) {
                _measure_row = @"";
            }else{
                ClassificationModel *model = _data2[indexPath.row];
                _measure_row  = model.tid;
            }
        }else if (indexPath.column == 2){
            if (indexPath.row == 0) {
                _type_row = @"";
            }else{
                CompensateModel *model = _data3[indexPath.row];
                _type_row = model.tid;
            }
        }else{
            if (indexPath.row == 0) {
                _statue_row = @"";
            }else{
                _statue_row = @"1";//0 1
            }
        }
        if (self.dataArr.count>0) {
            [self.dataArr removeAllObjects];
            [complainTable reloadData];
        }
        [self sendRequestComplainData:_page];
    }
    
}
- (void)createMainView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    complainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NVHeight+44, ViewWidth, ViewHeight-NVHeight-44) style:UITableViewStyleGrouped];
    complainTable.sectionHeaderHeight = 5;
    complainTable.sectionFooterHeight = 5;
    complainTable.delegate = self;
    complainTable.dataSource = self;
    [self.view addSubview:complainTable];
    complainTable.backgroundColor = RGBColor(242, 239, 247);
    [complainTable registerNib:[UINib nibWithNibName:@"ComplainCell" bundle:nil] forCellReuseIdentifier:@"complainCell"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    complainTable.tableHeaderView = view;
#pragma mark - MJ刷新
    complainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.refreshState = @"drop-down";//下拉状态
        self.page = 1;
        [self updateData];
    }];
    complainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.refreshState = @"pull";//上拉状态
        if (self.page < _allPage) {
            _page++;
            [self updateData];
            //NSLog(@"刷新前：%d",_page);
        }else{
            [complainTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
-(void)endRefresh{
    [complainTable.mj_header endRefreshing];
    [complainTable.mj_footer endRefreshing];
}
- (void)updateData{
    [self sendRequestComplainData:_page];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplainModel *model = _dataArr[indexPath.section];

    return [complainTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ComplainCell class] contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"complainCell" forIndexPath:indexPath];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplainDetailViewController *detail = [[ComplainDetailViewController alloc]init];
    ComplainModel *model = _dataArr[indexPath.section];
    detail.model = model;
    [detail update:^(NSInteger commentCount) {
        model.ynum = [NSString stringWithFormat:@"%ld",[model.ynum integerValue]+1];
        model.pnum = [NSString stringWithFormat:@"%ld",(long)commentCount];
        [complainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    PushController(detail)
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 缺少主管意见的字段 原因-1、补偿类型-1
- (void)sendRequestComplainData:(NSInteger)page
{
    if ([_refreshState isEqualToString:@"drop-down"]) {
        [_dataArr removeAllObjects];
        [complainTable reloadData];
    }
    if ([_refreshState isEqualToString:@"initLoad"]) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    }
    //<root><api><module>1702</module><type>0</type><query>{store=,reason=,bctype=,status=,page=1,size=10}</query></api><user><company>009</company><customeruser>15939010676</customeruser><phoneno>lblblblblblbtt</phoneno></user></root>
    NSString *str = @"<root><api><module>1702</module><type>0</type><query>{store=%@,reason=%@,bctype=%@,status=%@,page=%d,size=%d}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_organization_row,_measure_row,_type_row,_statue_row,page,SIZE,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
   // NSLog(@"%@",string);
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        //NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ComplainModel *model = [[ComplainModel alloc]init];
                    DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                    model.c_id = c_id.stringValue;
                    DDXMLElement *c_newid = [item elementsForName:@"c_newid"][0];
                    model.c_newid = c_newid.stringValue;
                    DDXMLElement *date = [item elementsForName:@"date"][0];
                    model.date = date.stringValue;
                    DDXMLElement *status = [item elementsForName:@"status"][0];
                    model.status = status.stringValue;
                    DDXMLElement *yy = [item elementsForName:@"yy"][0];
                    model.yy = yy.stringValue;
                    DDXMLElement *program = [item elementsForName:@"program"][0];
                    model.program = program.stringValue;
                    DDXMLElement *btype = [item elementsForName:@"btype"][0];
                    model.btype = btype.stringValue;
                    DDXMLElement *bc = [item elementsForName:@"bc"][0];
                    model.bc = bc.stringValue;
                    DDXMLElement *bm = [item elementsForName:@"bm"][0];
                    model.bm = bm.stringValue;
                    DDXMLElement *byj = [item elementsForName:@"byj"][0];
                    model.byj = byj.stringValue;
                    DDXMLElement *uyj = [item elementsForName:@"uyj"][0];
                    model.uyj = uyj.stringValue;
                    DDXMLElement *wname = [item elementsForName:@"wname"][0];
                    model.wname = wname.stringValue;
                    DDXMLElement *clientid = [item elementsForName:@"clientid"][0];
                    model.clientid = clientid.stringValue;
                    DDXMLElement *ynum = [item elementsForName:@"ynum"][0];
                    model.ynum = ynum.stringValue;
                    DDXMLElement *pnum = [item elementsForName:@"pnum"][0];
                    model.pnum = pnum.stringValue;
                    DDXMLElement *hname = [item elementsForName:@"hname"][0];
                    model.hname = hname.stringValue;
                    [self.dataArr addObject:model];
                    
                    NSArray *allpageArr = [doc nodesForXPath:@"//allpage" error:nil];
                    for (DDXMLElement *item in allpageArr) {
                        self.allPage = [item.stringValue integerValue];
                    }
                }
                [complainTable reloadData];
            }
            [self endRefresh];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    } failure:^(NSError *error) {
        [self endRefresh];
        //无网络加载失败时显
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
