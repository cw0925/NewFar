//
//  RemindBirthdayViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "RemindBirthdayViewController.h"
#import "BirthdayCell.h"
#import "BlessViewController.h"
#import "BirthModel.h"
#import "NewsViewController.h"

@interface RemindBirthdayViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation RemindBirthdayViewController
{
    UITableView *birthTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"生日提醒" hasLeft:YES hasRight:YES withRightBarButtonItemImage:@"news"];
    
    [self initUI];
    [self sendRequestRemindBirthData];
}
//- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image
//{
//    [super customNavigationBar:title hasLeft:isLeft hasRight:isRight withRightBarButtonItemImage:image];
//    
//    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
//    right.frame = CGRectMake(0, 0,25,25);
//    [right setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [right addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
//}
- (void)rightBarClick
{
    NewsViewController *news = [[NewsViewController alloc]init];
    PushController(news)
}
- (void)initUI
{
    birthTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    birthTable.delegate = self;
    birthTable.dataSource = self;
    birthTable.rowHeight = 66;
    birthTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:birthTable];
    [birthTable registerNib:[UINib nibWithNibName:@"BirthdayCell" bundle:nil] forCellReuseIdentifier:@"birthdayCell"];
    
    UIView *foot = [[UIView alloc]init];
    birthTable.tableFooterView = foot;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BirthdayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"birthdayCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BirthModel *model = _dataArr[indexPath.row];
    [cell configCell:model];
    [cell.blessBtn addTarget:self action:@selector(blessClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)blessClick:(UIButton *)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint Position = [touch locationInView:birthTable];
    NSIndexPath *indexPath= [birthTable indexPathForRowAtPoint:Position];
    
    BirthModel *model = _dataArr[indexPath.row];
    BlessViewController *bless = [[BlessViewController alloc]init];
    bless.name = model.name;
    bless.phone = model.tel;
    PushController(bless)
}
- (void)sendRequestRemindBirthData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>1302</module><type>0</type><query></query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
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
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    BirthModel *model = [[BirthModel alloc]init];
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *tx = [item elementsForName:@"tx"][0];
                    model.tx = tx.stringValue;
                    DDXMLElement *sr = [item elementsForName:@"sr"][0];
                    model.sr = sr.stringValue;
                    DDXMLElement *tel = [item elementsForName:@"tel"][0];
                    model.tel = tel.stringValue;
                    [self.dataArr addObject:model];
                }
                [birthTable reloadData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
