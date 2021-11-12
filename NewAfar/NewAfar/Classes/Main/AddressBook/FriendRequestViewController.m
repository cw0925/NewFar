//
//  FriendRequestViewController.m
//  NewFarSoft
//
//  Created by CW on 16/8/23.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "FriendRequestViewController.h"
#import "RequestFriendModel.h"
#import "RequestFriendCell.h"

@interface FriendRequestViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation FriendRequestViewController
{
    UITableView *requestTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"好友请求" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestFriendRequestData];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    requestTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth, ViewHeight-64) style:UITableViewStyleGrouped];
    requestTable.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:249/255.0 alpha:0.5];
    requestTable.delegate = self;
    requestTable.dataSource = self;
    requestTable.sectionHeaderHeight = 5;
    requestTable.sectionFooterHeight = 5;
    [self.view addSubview:requestTable];
    
    [requestTable registerNib:[UINib nibWithNibName:@"RequestFriendCell" bundle:nil] forCellReuseIdentifier:@"requestCell"];
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 10)];
    requestTable.tableHeaderView = head;
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
    RequestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RequestFriendModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    
    [cell.agree addTarget:self action:@selector(allowFriendRequestClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.refuse addTarget:self action:@selector(refuseFriendRequestClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
//同意好友请求
- (void)allowFriendRequestClick:(UIButton *)sender
{
    RequestFriendCell *cell = (RequestFriendCell *)sender.superview.superview;//获取cell
    NSIndexPath *index = [requestTable indexPathForCell:cell];//获取cell对应的section
    RequestFriendModel *model = _dataArr[index.section];
    [self sendRequsetReplyRequestData:model.c_id withType:@"1" phone:model.c_phone];
    NSLog(@"同意：点击第%ld行",(long)index.section);
}
//拒绝好友请求
- (void)refuseFriendRequestClick:(UIButton *)sender
{
    RequestFriendCell *cell = (RequestFriendCell *)sender.superview.superview;//获取cell
    NSIndexPath *index = [requestTable indexPathForCell:cell];//获取cell对应的section
    RequestFriendModel *model = _dataArr[index.section];
    [self sendRequsetReplyRequestData:model.c_id withType:@"2" phone:model.c_phone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 查询待添加好友
- (void)sendRequestFriendRequestData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>1102</module><type>0</type><query></query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
         DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                [self.view makeToast:element.stringValue];
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
                    RequestFriendModel *model = [[RequestFriendModel alloc]init];
                    DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                    model.c_id = c_id.stringValue;
                    DDXMLElement *nc = [item elementsForName:@"nc"][0];
                    model.nc = nc.stringValue;
                    DDXMLElement *c_phone = [item elementsForName:@"c_phone"][0];
                    model.c_phone = c_phone.stringValue;
                    [self.dataArr addObject:model];
                }
                [requestTable reloadData];
            }
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
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
#pragma mark - 返回数据有问题
//回复好友请求-1:同意、2拒绝
- (void)sendRequsetReplyRequestData:(NSString *)cell_id withType:(NSString *)type phone:(NSString *)phone
{
    NSString *str = @"<root><api><module>1103</module><type>0</type><query>{c_id=%@,type=%@,alias=%@}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,cell_id,type,phone,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            [self.view makeToast:element.stringValue];
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
