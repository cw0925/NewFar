//
//  CheckResultViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/18.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CheckResultViewController.h"
#import "PromotionModel.h"
#import "ProStartCell.h"
#import "ProStartDetailViewController.h"
#import "PromotionEndCell.h"
#import "FHeaderView.h"

@interface CheckResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *stateArr;

@end

@implementation CheckResultViewController
{
    NSString *string;
    UITableView *checkTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self createMainView];
    [self sendRequestCheckData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)initUI
{
    if ([_module isEqualToString:@"0804"]) {
        [self customNavigationBar:@"促销开始检查" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    }
    if ([_module isEqualToString:@"0805"]) {
        [self customNavigationBar:@"促销结束检查" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    }
}
- (void)createMainView
{
    checkTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 10+64, ViewWidth-20, ViewHeight-64-20) style:UITableViewStylePlain];
    checkTable.delegate = self;
    checkTable.dataSource = self;
    checkTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:checkTable];
    if ([_module isEqualToString:@"0804"]) {
        checkTable.rowHeight = 50;
        [checkTable registerNib:[UINib nibWithNibName:@"ProStartCell" bundle:nil] forCellReuseIdentifier:@"proStartCell"];
    }else
    {
        checkTable.rowHeight = 200;
        checkTable.sectionHeaderHeight = 40;
        [checkTable registerNib:[UINib nibWithNibName:@"PromotionEndCell" bundle:nil] forCellReuseIdentifier:@"promotionEndCell"];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([_module isEqualToString:@"0805"]) {
        return _dataArr.count;
    }else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_module isEqualToString:@"0804"]) {
        return _dataArr.count;
    }else
    {
        if (![_stateArr[section] boolValue]) {
            return 0;
        }
        return 1;
    }
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
    UIImageView *bgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(checkTable.frame),35)];
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
    [checkTable reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    if ([_module isEqualToString:@"0804"]) {
        ProStartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"proStartCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        PromotionModel *model = _dataArr[indexPath.row];
        [cell configCell:model];
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(checkTable.frame), 40)];
        imv.image = [UIImage imageNamed:@"21"];
        [cell insertSubview:imv atIndex:0];
        return cell;
    }else
    {
        PromotionEndCell *cell = [tableView dequeueReusableCellWithIdentifier:@"promotionEndCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(checkTable.frame), 200)];
        imv.image = [UIImage imageNamed:@"cellbg"];
        [cell insertSubview:imv atIndex:0];
        PromotionModel *model = _dataArr[indexPath.section];
        [cell configCell:model];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_module isEqualToString:@"0804"]) {
        PromotionModel *model = _dataArr[indexPath.section];
        NSArray *arr = [model.adno componentsSeparatedByString:@" "];
        ProStartDetailViewController *startDetail = [[ProStartDetailViewController alloc]init];
        startDetail.category = arr[0];
        startDetail.date = _sDate;
        PushController(startDetail)
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)sendRequestCheckData
{
    _dataArr = [NSMutableArray array];
    _stateArr = [NSMutableArray array];
    //促销开始0804,促销结束0805
    NSString *queryS = [NSString stringWithFormat:@"{depart=%@,type=1,s_dt=%@}",_depart,_sDate];
    NSString *queryE = [NSString stringWithFormat:@"{depart=%@,s_dt=%@}",_depart,_eDate];
    NSString *str = @"<root><api><module>%@</module><type>0</type><query>%@</query></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    if ([_module isEqualToString:@"0804"]) {
        string = [NSString stringWithFormat:str,_module,queryS];
        [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
            NSData *data = (NSData *)responseObject;
            DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
            NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
            for (DDXMLElement *element in msgArr) {
                if (![element.stringValue isEqualToString:@"查询成功"]) {
                    [self.view makeToast:element.stringValue];
                }else
                {
                    NSLog(@"%@",doc);
                    NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                    for (DDXMLElement *item in rowArr) {
                        PromotionModel *model = [[PromotionModel alloc]init];
                        DDXMLElement *qty = [item elementsForName:@"qty"][0];
                        model.qty = qty.stringValue;
                        DDXMLElement *adno = [item elementsForName:@"adno"][0];
                        model.adno = adno.stringValue;
                        [_dataArr addObject:model];
                    }
                    [checkTable reloadData];
                }
            }
        } failure:^(NSError *error) {
            
        }];

    }else
    {
        string = [NSString stringWithFormat:str,_module,queryE];
        [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
            NSData *data = (NSData *)responseObject;
            DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
            NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
            for (DDXMLElement *element in msgArr) {
                if (![element.stringValue isEqualToString:@"查询成功"]) {
                    [self.view makeToast:element.stringValue];
                }else
                {
                    NSLog(@"%@",doc);
                    NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                    for (DDXMLElement *element in rowArr) {
                        PromotionModel *model = [[PromotionModel alloc]init];
                        DDXMLElement *adno = [element elementsForName:@"adno"][0];
                        model.adno = adno.stringValue;
                        DDXMLElement *name = [element elementsForName:@"name"][0];
                        model.name = name.stringValue;
                        DDXMLElement *code = [element elementsForName:@"code"][0];
                        model.code = code.stringValue;
                        DDXMLElement *cname = [element elementsForName:@"cname"][0];
                        model.cname = cname.stringValue;
                        DDXMLElement *cxjj = [element elementsForName:@"cxjj"][0];
                        model.cxjj = cxjj.stringValue;
                        DDXMLElement *cxsj = [element elementsForName:@"cxsj"][0];
                        model.cxsj = cxsj.stringValue;
                        DDXMLElement *cxlx = [element elementsForName:@"cxlx"][0];
                        model.cxlx = cxlx.stringValue;
                        DDXMLElement *dhedt = [element elementsForName:@"dhedt"][0];
                        model.dhedt = dhedt.stringValue;
                        DDXMLElement *cxedt = [element elementsForName:@"cxedt"][0];
                        model.cxedt = cxedt.stringValue;
                        DDXMLElement *jhcx = [element elementsForName:@"jhcx"][0];
                        model.jhcx = jhcx.stringValue;
                        DDXMLElement *sjcx = [element elementsForName:@"sjcx"][0];
                        model.sjcx = sjcx.stringValue;
                        [self.dataArr addObject:model];
                        [self.stateArr addObject:[NSNumber numberWithBool:NO]];
                    }

                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
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
