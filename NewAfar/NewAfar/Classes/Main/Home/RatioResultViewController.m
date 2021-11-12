//
//  RatioResultViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/17.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "RatioResultViewController.h"
#import "OrganizationProModel.h"
#import "SHeaderView.h"
#import "RatioCell.h"

@interface RatioResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *stateArr;
@end

@implementation RatioResultViewController
{
    NSString *string;
    UITableView *ratioTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createMainView];
    [self initUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark - 判断条件有问题，当部门和分类同时为空时无法判断查询类型
- (void)initUI
{
    if ([_departCode isEqualToString:@""]&&[_classifyCode isEqualToString:@""]) {
        [self customNavigationBar:@"机构促销占比查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
        [self sendRequestRatioData:@"0801"];
    }else if (![_departCode isEqualToString:@""]&&[_classifyCode isEqualToString:@""]){
        [self customNavigationBar:@"部门促销占比查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
        [self sendRequestRatioData:@"0802"];
    }else
    {
        [self customNavigationBar:@"分类促销占比查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
        [self sendRequestRatioData:@"0803"];
    }
}
- (void)createMainView
{
    ratioTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 64+10, ViewWidth-20, ViewHeight-64-20) style:UITableViewStylePlain];
    ratioTable.delegate = self;
    ratioTable.dataSource = self;
    ratioTable.sectionHeaderHeight = 50;
    ratioTable.rowHeight = 83;
    ratioTable.backgroundColor = [UIColor clearColor];
    ratioTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:ratioTable];
    [ratioTable registerNib:[UINib nibWithNibName:@"RatioCell" bundle:nil] forCellReuseIdentifier:@"ratioCell"];
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
    SHeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"SHeaderView" owner:self options:nil]lastObject];
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
    OrganizationProModel *model = _dataArr[section];
    header.title.text = [NSString stringWithFormat:@"%@ %@",model.c_id,model.name];
    header.desc.text = [NSString stringWithFormat:@"促销金额(元):%.02f",[model.cxje doubleValue]];
    
    header.itemBtn.tag = section + 1;
    [header.itemBtn addTarget:self action:@selector(sectionHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //背景
    UIImageView *bgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(ratioTable.frame),45)];
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
    [ratioTable reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    //右边的图标
    UIButton *btn = [self.view viewWithTag:index+100000];
    btn.selected = [_stateArr[index] boolValue];
}

// 去掉UItableview sectionheaderview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RatioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ratioCell" forIndexPath:indexPath];
    cell.backgroundColor = RGBColor(206, 239, 254);
    OrganizationProModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//机构促销占比-0801、部门促销占比- 0802、分类促销占比-0803
- (void)sendRequestRatioData:(NSString *)module
{
    NSString *organQuery = [NSString stringWithFormat:@"{store=%@,s_dt=%@,e_dt=%@}",_organizationCode,_startDate,_endDate];
    NSString *departQuery = [NSString stringWithFormat:@"{depart=%@,len=%@,s_dt=%@,store=%@,e_dt=%@}",_departCode,_departLen,_startDate,_organizationCode,_endDate];
    NSString *classifyQuery = [NSString stringWithFormat:@"{ccode=%@,len=%@,s_dt=%@,store=%@,e_dt=%@}",_classifyCode,_classifyLen,_startDate,_organizationCode,_endDate];
    
    NSString *str = @"<root><api><module>%@</module><type>0</type><query>%@</query></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    if ([module isEqualToString:@"0801"]) {
        string = [NSString stringWithFormat:str,module,organQuery];
    }else if ([module isEqualToString:@"0802"]){
        string = [NSString stringWithFormat:str,module,departQuery];
    }else
    {
        string = [NSString stringWithFormat:str,module,classifyQuery];
    }
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
         NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                [self.view makeToast:element.stringValue];
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                        OrganizationProModel *model = [[OrganizationProModel alloc]init];
                        DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                        model.c_id = c_id.stringValue;
                        DDXMLElement *name = [item elementsForName:@"name"][0];
                        model.name = name.stringValue;
                        DDXMLElement *cxje = [item elementsForName:@"cxje"][0];
                        model.cxje = cxje.stringValue;
                        DDXMLElement *cxzb = [item elementsForName:@"cxzb"][0];
                        model.cxzb = cxzb.stringValue;
                        DDXMLElement *cxml = [item elementsForName:@"cxml"][0];
                        model.cxml = cxml.stringValue;
                        DDXMLElement *cxmlzb = [item elementsForName:@"cxmlzb"][0];
                        model.cxmlzb = cxmlzb.stringValue;
                        DDXMLElement *cxmll = [item elementsForName:@"cxmll"][0];
                        model.cxmll = cxmll.stringValue;
                        [self.dataArr addObject:model];
                        [self.stateArr addObject:[NSNumber numberWithBool:NO]];
                }
            }
            [ratioTable reloadData];
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
