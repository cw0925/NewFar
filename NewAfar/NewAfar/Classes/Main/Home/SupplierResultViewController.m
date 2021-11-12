//
//  SupplierResultViewController.m
//  NewAfar
//
//  Created by huanghuixiang on 16/9/5.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "SupplierResultViewController.h"
#import "SupplierModel.h"
#import "SHeaderView.h"
#import "SupplierCell.h"

@interface SupplierResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *stateArr;

@end

@implementation SupplierResultViewController
{
    UITableView *supplierTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"供应商销售查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestSupplierData];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)initUI
{
    supplierTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 10+64, ViewWidth-20, ViewHeight-20-64) style:UITableViewStylePlain];
    supplierTable.delegate = self;
    supplierTable.dataSource = self;
    supplierTable.rowHeight = 130;
    supplierTable.sectionHeaderHeight = 50;
    supplierTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:supplierTable];
    
    [supplierTable registerNib:[UINib nibWithNibName:@"SupplierCell" bundle:nil] forCellReuseIdentifier:@"supplierCell"];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SHeaderView *head = [[[NSBundle mainBundle]loadNibNamed:@"SHeaderView" owner:self options:nil]lastObject];
    head.backgroundColor = [UIColor clearColor];
    //背景
    UIImageView *bgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(supplierTable.frame), 45)];
    bgHeader.image = [UIImage imageNamed:@"21"];
    [head insertSubview:bgHeader atIndex:0];
    
    head.itemBtn.tag = section+3;
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
    SupplierModel *model = _dataArr[section];
    head.title.text = [NSString stringWithFormat:@"%@",model.gysname];
    head.desc.text = [NSString stringWithFormat:@"净收款额(元):%.02f",[model.amt doubleValue]];
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
    NSInteger index = sender.tag - 3;
    BOOL isClick = [_stateArr[index] boolValue];
    //改变这个值
    [_stateArr replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!isClick]];
    //刷新视图
    [supplierTable reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    //右边的图标
    UIButton *btn = [self.view viewWithTag:index+1000];
    btn.selected = [_stateArr[index] boolValue];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArr.count == 1) {
        return 0;
    }else
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
    SupplierCell *cell = [tableView dequeueReusableCellWithIdentifier:@"supplierCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = RGBColor(206, 239, 254);
    SupplierModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestSupplierData
{
    //播放加载动画

    NSString *str = @"<root><api><module>0207</module><type>0</type><query>{store=%@,depart=%@,ccode=%@,type=%@,provider=%@,s_dt=%@,e_dt=%@}</query></api><user><company>009105</company><customeruser>18516901925</customeruser></user></root>";
    
    NSString *string = [NSString stringWithFormat:str,_organizationCode,_departCode,_classifyCode,_goodType,_supplier,_startDate,_endDate];
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for ( DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                
                [self.view.window makeToast:element.stringValue];
                // 停止动画
            }else
            {
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    SupplierModel *model = [[SupplierModel alloc]init];
                    DDXMLElement *gysno = [item elementsForName:@"gysno"][0];
                    model.gysno = gysno.stringValue;
                    DDXMLElement *gysname = [item elementsForName:@"gysname"][0];
                    model.gysname = gysname.stringValue;
                    DDXMLElement *customers = [item elementsForName:@"customers"][0];
                    model.customers = customers.stringValue;
                    DDXMLElement *amt = [item elementsForName:@"amt"][0];
                    model.amt = amt.stringValue;
                    DDXMLElement *qty = [item elementsForName:@"qty"][0];
                    model.qty = qty.stringValue;
                    DDXMLElement *kdj = [item elementsForName:@"kdj"][0];
                    model.kdj = kdj.stringValue;
                    DDXMLElement *ml = [item elementsForName:@"ml"][0];
                    model.ml = ml.stringValue;
                    DDXMLElement *mll = [item elementsForName:@"mll"][0];
                    model.mll = mll.stringValue;
                    [self.dataArr addObject:model];
                    [self.stateArr addObject:[NSNumber numberWithBool:NO]];
                    //NSLog(@"1：%@",model.gysname);
                }
                if (_dataArr.count == 1) {
                    [self.view makeToast:@"无数据"];
                }
                [supplierTable reloadData];
                // 停止动画
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
- (NSMutableArray *)supplierArr
{
    if (!_stateArr) {
        _stateArr = [NSMutableArray array];
    }
    return _stateArr;
}
@end
