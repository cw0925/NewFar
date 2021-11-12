//
//  GoodSaleResultViewController.m
//  NewFarSoft
//
//  Created by huanghuixiang on 16/9/1.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "GoodSaleResultViewController.h"
#import "GoodModel.h"
#import "GoodRealTimeCell.h"
#import "SHeaderView.h"

@interface GoodSaleResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *stateArr;

@end

@implementation GoodSaleResultViewController
{
    UITableView *goodTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"商品销售统计" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
    [self sendRequestGoodResultData:@"DD"];
}
- (void)initUI
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10,ViewWidth, 35)];
    [self.view addSubview:headView];
    NSArray *titleArr = @[@"本日",@"昨日",@"本周",@"上周",@"本月",];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(10*(i+1)+((ViewWidth-60)/5)*i,0,(ViewWidth-60)/5,35);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_regist"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1000000;
        if (btn.tag == 1000000) {
            btn.selected = YES;
        }
        [headView addSubview:btn];
    }
    
    goodTable = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headView.frame)+10, ViewWidth-20, ViewHeight-CGRectGetMaxY(headView.frame)-20) style:UITableViewStylePlain];
    goodTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:goodTable];
    goodTable.rowHeight = 130;
    goodTable.sectionHeaderHeight = 50;
    goodTable.delegate = self;
    goodTable.dataSource = self;
    [goodTable registerNib:[UINib nibWithNibName:@"GoodRealTimeCell" bundle:nil] forCellReuseIdentifier:@"goodRealTimeCell"];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SHeaderView *head = [[[NSBundle mainBundle]loadNibNamed:@"SHeaderView" owner:self options:nil]lastObject];
    head.backgroundColor = [UIColor clearColor];
    //背景
    UIImageView *bgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(goodTable.frame), 45)];
    if (section == 0) {
        bgHeader.image = [UIImage imageNamed:@"21"];
    }else
    {
        bgHeader.image = [UIImage imageNamed:@"21"];
    }
    [head insertSubview:bgHeader atIndex:0];
    
    head.itemBtn.tag = section+1;
    //右边的图标
    head.picBtn.tag = section +1000;
     head.picBtn.tintColor = [UIColor clearColor];
    if ([_stateArr[section] boolValue]) {
         head.picBtn.selected = YES;
    }else
    {
         head.picBtn.selected = NO;
    }
    
    [head.itemBtn addTarget:self action:@selector(sectionHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
    GoodModel *model = _dataArr[section];
    head.title.text = model.NAME;
    head.desc.text = [NSString stringWithFormat:@"净收款额(元):%.02f",[model.amt floatValue]];
    return  head;
}
// 去掉UItableview sectionheaderview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 45;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)sectionHeaderClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 1;
    BOOL isClick = [_stateArr[index] boolValue];
    //改变这个值
    [_stateArr replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!isClick]];
    //刷新视图
    [goodTable reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    //右边的图标
    UIButton *btn = [self.view viewWithTag:index+1000];
    btn.selected = [_stateArr[index] boolValue];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![_stateArr[section] boolValue]) {
        return 0;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GoodRealTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodRealTimeCell" forIndexPath:indexPath];
    cell.backgroundColor = RGBColor(206, 239, 254);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
#pragma mark - 点击不同的分栏按钮对应不同的数据源
//点击分栏按钮
- (void)btnClick:(UIButton *)sender
{
    //处理按钮的背景切换
    for (NSInteger i=0; i<5; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+1000000];
        btn.selected = NO;
    }
    sender.selected = YES;
    switch (sender.tag) {
        case 1000000:
            [self sendRequestGoodResultData:@"DD"];
            break;
        case 1000001:
            [self sendRequestGoodResultData:@"QQ"];
            break;
        case 1000002:
            [self sendRequestGoodResultData:@"WK"];
            break;
        case 1000003:
            [self sendRequestGoodResultData:@"YY"];
            break;
        case 1000004:
            [self sendRequestGoodResultData:@"MM"];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestGoodResultData:(NSString *)type
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>0105</module><type>0</type><query>{gcode=%@,barcode=%@,name=%@,store=%@,type=%@}</query></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_goodcode,_barcode,_goodname,_organization,type];
   [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        NSLog(@"%@",doc);
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                [self.view makeToast:element.stringValue];
            }else
            {
                NSArray *arr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in arr) {
                    GoodModel *model = [[GoodModel alloc]init];
                    DDXMLElement *gcode = [item elementsForName:@"gcode"][0];
                    model.gcode = gcode.stringValue;
                    DDXMLElement *barcode = [item elementsForName:@"barcode"][0];
                    model.barcode = barcode.stringValue;
                    DDXMLElement *NAME = [item elementsForName:@"NAME"][0];
                    model.NAME = NAME.stringValue;
                    DDXMLElement *amt = [item elementsForName:@"amt"][0];
                    model.amt = amt.stringValue;
                    DDXMLElement *ml = [item elementsForName:@"ml"][0];
                    model.ml = ml.stringValue;
                    DDXMLElement *mll = [item elementsForName:@"mll"][0];
                    model.mll = mll.stringValue;
                    DDXMLElement *customers = [item elementsForName:@"customers"][0];
                    model.customers = customers.stringValue;
                    DDXMLElement *kdj = [item elementsForName:@"kdj"][0];
                    model.kdj = kdj.stringValue;
                    [self.dataArr addObject:model];
                    [self.stateArr addObject:[NSNumber numberWithBool:NO]];
                }
                [goodTable reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
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
- (NSMutableArray *)stateArr
{
    if (!_stateArr) {
        _stateArr = [NSMutableArray array];
    }
    return _stateArr;
}
@end
