//
//  MyAttentionViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "AttentionModel.h"
#import "MyAttentionCell.h"
#import "FriendInfoViewController.h"

@interface MyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation MyAttentionViewController
{
    UITableView *myAtTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"我关注的" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestMyAttentionData];
}
- (void)initUI
{
    myAtTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    myAtTable.delegate = self;
    myAtTable.dataSource = self;
    myAtTable.rowHeight = 60;
    myAtTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:myAtTable];
    [myAtTable registerNib:[UINib nibWithNibName:@"MyAttentionCell" bundle:nil] forCellReuseIdentifier:@"attentionCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attentionCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AttentionModel *model = _dataArr[indexPath.row];
    [cell configCell:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionModel *model = _dataArr[indexPath.row];
    FriendInfoViewController *info = [[FriendInfoViewController alloc]init];
    info.phone = model.tel;
    info.type = @"none";
    PushController(info)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 数据源
- (void)sendRequestMyAttentionData
{
   [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>1303</module><type>0</type><query>{type=1}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],UUID];
    
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
                    AttentionModel *model = [[AttentionModel alloc]init];
                    DDXMLElement *nc = [item elementsForName:@"nc"][0];
                    model.nc = nc.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    model.tx = tx.stringValue;
                    DDXMLElement *tel = [item elementsForName:@"tel"][0];
                    model.tel = tel.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    [self.dataArr addObject:model];
                }
                [myAtTable reloadData];
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
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
