//
//  ProStartDetailViewController.m
//  NewFarSoft
//
//  Created by huanghuixiang on 16/8/31.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "ProStartDetailViewController.h"
#import "PromotionModel.h"
#import "FHeaderView.h"
#import "ProStartDetailCell.h"

@interface ProStartDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *stateArr;

@end

@implementation ProStartDetailViewController
{
    UITableView *detailTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"促销开始查询详情" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
    [self sendRequestStartDetailData];
}
- (void)initUI
{
    detailTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, ViewWidth-20, ViewHeight-20) style:UITableViewStylePlain];
    detailTable.delegate = self;
    detailTable.dataSource = self;
    detailTable.rowHeight = 165;
    detailTable.sectionHeaderHeight = 40;
    detailTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:detailTable];
    [detailTable registerNib:[UINib nibWithNibName:@"ProStartDetailCell" bundle:nil] forCellReuseIdentifier:@"proStartDetailCell"];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FHeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"FHeaderView" owner:self options:nil]lastObject];
    header.backgroundColor = [UIColor clearColor];
    //右侧指示图
    header.picBtn.tag = section + 100000;
    header.picBtn.tintColor = [UIColor clearColor];
    if ([_stateArr[section] boolValue]) {
        header.picBtn.selected = YES;
    }else
    {
        header.picBtn.selected = NO;
    }
    PromotionModel *model = _dataArr[section];
    header.title.text = [NSString stringWithFormat:@" %@",model.adno];
    
    header.itemBtn.tag = section + 1;
    [header.itemBtn addTarget:self action:@selector(sectionHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
    //背景
    UIImageView *bgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(detailTable.frame),35)];
    bgHeader.image = [UIImage imageNamed:@"21"];
    [header insertSubview:bgHeader atIndex:0];
    return header;
}
- (void)sectionHeaderClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 1;
    BOOL isClick = [_stateArr[index] boolValue];
    //改变这个值
    [_stateArr replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!isClick]];
    //刷新视图
    [detailTable reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    //右边的图标
    UIButton *btn = [self.view viewWithTag:index+100000];
    btn.selected = [_stateArr[index] boolValue];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProStartDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"proStartDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = RGBColor(206, 239, 254);
    PromotionModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestStartDetailData
{
     NSString *str = @"<root><api><module>0804</module><type>0</type><query>{depart=%@,type=2,s_dt=%@}</query></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_category,_date];
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
       // NSLog(@"%@",doc);
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                [self.view makeToast:element.stringValue];
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    PromotionModel *model = [[PromotionModel alloc]init];
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *adno = [item elementsForName:@"adno"][0];
                    model.adno = adno.stringValue;
                    DDXMLElement *code = [item elementsForName:@"code"][0];
                    model.code = code.stringValue;
                    DDXMLElement *cname = [item elementsForName:@"cname"][0];
                    model.cname = cname.stringValue;
                    DDXMLElement *cxjj = [item elementsForName:@"cxjj"][0];
                    model.cxjj = cxjj.stringValue;
                    DDXMLElement *cxsj = [item elementsForName:@"cxsj"][0];
                    model.cxsj = cxsj.stringValue;
                    DDXMLElement *cxlx = [item elementsForName:@"cxlx"][0];
                    model.cxlx = cxlx.stringValue;
                    DDXMLElement *dhsdt = [item elementsForName:@"dhsdt"][0];
                    model.dhsdt = dhsdt.stringValue;
                    DDXMLElement *cxsdt = [item elementsForName:@"cxsdt"][0];
                    model.cxsdt = cxsdt.stringValue;
                    [self.dataArr addObject:model];
                    [self.stateArr addObject:[NSNumber numberWithBool:NO]];
                }
                [detailTable reloadData];
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
- (NSMutableArray *)stateArr
{
    if (!_stateArr) {
        _stateArr = [NSMutableArray array];
    }
    return _stateArr;
}
@end
