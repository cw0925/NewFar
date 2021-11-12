//
//  NewsViewController.m
//  NewAfar
//
//  Created by cw on 17/2/10.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsModel.h"
#import "NewsCell.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,copy)NSMutableArray *dataArr;
@end

@implementation NewsViewController
{
    UITableView *newsTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"消息中心" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestNewsData];
}
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
{
    [super customNavigationBar:title hasLeft:isLeft hasRight:isRight withRightBarButtonItemImage:image];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.titleLabel.font = [UIFont systemFontWithSize:14];
    [right setTitleColor:RGBColor(18,184,246) forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 60, 30);
    [right setTitle:@"清空" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(clearAll:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
}
- (void)clearAll:(UIButton *)sender{
    if (_dataArr.count ==0) {
        [self.view makeToast:@"暂无数据！"];
    }else{
        [self sendRequestClearAllData];
    }
}
- (void)initUI{
    newsTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    newsTable.delegate = self;
    newsTable.dataSource = self;
    [self.view addSubview:newsTable];
    [newsTable registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"newsCell"];
    
    UIView *foot = [[UIView alloc]init];
    newsTable.tableFooterView = foot;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = _dataArr[indexPath.row];
    return [newsTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewsCell class] contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//消息数据
- (void)sendRequestNewsData{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>1307</module><type>0</type><query></query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                //无数据时显示
                self.isShowEmptyData = YES;
                self.noDataImgName = @"cb";
                
                [self.view addSubview:self.xlTableView];
                
                self.xlTableView.emptyDataSetSource = self;
                self.xlTableView.emptyDataSetDelegate = self;
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    NewsModel *model = [[NewsModel alloc]init];
                    DDXMLElement *c_name = [item elementsForName:@"c_name"][0];
                    model.c_name = c_name.stringValue;
                    DDXMLElement *c_real_name = [item elementsForName:@"c_real_name"][0];
                    model.c_real_name = c_real_name.stringValue;
                    DDXMLElement *c_addresszc = [item elementsForName:@"c_addresszc"][0];
                    model.c_addresszc = c_addresszc.stringValue;
                    DDXMLElement *c_content = [item elementsForName:@"c_content"][0];
                    model.c_content = c_content.stringValue;
                    DDXMLElement *c_reciver = [item elementsForName:@"c_reciver"][0];
                    model.c_reciver = c_reciver.stringValue;
                    DDXMLElement *c_recrealname = [item elementsForName:@"c_recrealname"][0];
                    model.c_recrealname = c_recrealname.stringValue;
                    DDXMLElement *c_recaddresszc = [item elementsForName:@"c_recaddresszc"][0];
                    model.c_recaddresszc = c_recaddresszc.stringValue;
                    DDXMLElement *c_datetime = [item elementsForName:@"c_datetime"][0];
                    model.c_datetime = c_datetime.stringValue;
                    [self.dataArr addObject:model];
                }
            }
            [newsTable reloadData];
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
//清空数据
- (void)sendRequestClearAllData{
    NSString *str = @"<root><api><module>1308</module><type>0</type><query>{type=0}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"删除成功！"]) {
                [self sendRequestNewsData];
                [self.view makeToast:@"清空成功！"];
            }else{
               [self.view makeToast:@"清空失败！"];
            }
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
