//
//  ClassifyHisViewController.m
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ClassifyHisViewController.h"
#import "ClassifyHisModel.h"
#import "ClassifyHisCell.h"

@interface ClassifyHisViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation ClassifyHisViewController
{
    UITableView *classifyHisTable;
    UIView *head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"销售数据查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestClassifyHisData];
}
- (void)initUI
{
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    classifyHisTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight+40, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    classifyHisTable.backgroundColor = BaseColor;
    classifyHisTable.delegate = self;
    classifyHisTable.dataSource = self;
    classifyHisTable.sectionFooterHeight = 0;
    classifyHisTable.sectionHeaderHeight = 1;
    classifyHisTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    [self.view addSubview:classifyHisTable];
    [classifyHisTable registerNib:[UINib nibWithNibName:@"ClassifyHisCell" bundle:nil] forCellReuseIdentifier:@"classifyHisCell"];
    
    head =[[[NSBundle mainBundle]loadNibNamed:@"ClassifyHisCell" owner:self options:nil] lastObject];
    head.backgroundColor = CellColor;
    [head setFrame:CGRectMake(0,NavigationBarHeight, ViewWidth, 40)];
    [self.view addSubview:head];
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyHisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classifyHisCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    ClassifyHisModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
#pragma mark - 横屏
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
- (void)backPage
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestClassifyHisData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view ];
    
    NSString *str = @"<root><api><module>0203</module><type>0</type><query>{ccode=%@,len=%@,store=%@,s_dt=%@,e_dt=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    
    NSString *string = [NSString stringWithFormat:str,_classify,_length,_store,_startDate,_endDate,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                head.hidden = YES;
                [self.view makeToast:element.stringValue];
            }else{
                head.hidden = NO;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ClassifyHisModel *model = [[ClassifyHisModel alloc]init];
                    if ([item elementsForName:@"c_ccode"].count>0) {
                        DDXMLElement *c_ccode = [item elementsForName:@"c_ccode"][0];
                        model.c_ccode = c_ccode.stringValue;
                    }else{
                        model.c_ccode = @"";
                    }
                    if ([item elementsForName:@"name"].count>0) {
                        DDXMLElement *name = [item elementsForName:@"name"][0];
                        model.name = name.stringValue;
                    }else{
                        model.name = @"";
                    }
                    if ([item elementsForName:@"amt"].count>0) {
                        DDXMLElement *amt = [item elementsForName:@"amt"][0];
                        model.amt = amt.stringValue;
                    }else{
                        model.amt = @"";
                    }
                    if ([item elementsForName:@"cxamt"].count>0) {
                        DDXMLElement *cxamt = [item elementsForName:@"cxamt"][0];
                        model.cxamt = cxamt.stringValue;
                    }else{
                        model.cxamt = @"";
                    }
                    if ([item elementsForName:@"ml"].count>0) {
                        DDXMLElement *ml = [item elementsForName:@"ml"][0];
                        model.ml = ml.stringValue;
                    }else{
                        model.ml = @"";
                    }
                    if ([item elementsForName:@"mll"].count>0) {
                        DDXMLElement *mll = [item elementsForName:@"mll"][0];
                        model.mll = mll.stringValue;
                    }else{
                        model.mll = @"";
                    }
                    if ([item elementsForName:@"customers"].count>0) {
                        DDXMLElement *customers = [item elementsForName:@"customers"][0];
                        model.customers = customers.stringValue;
                    }else{
                        model.customers = @"";
                    }
                    if ([item elementsForName:@"kdj"].count>0) {
                        DDXMLElement *kdj = [item elementsForName:@"kdj"][0];
                        model.kdj = kdj.stringValue;
                    }else{
                        model.kdj = @"";
                    }
                    [self.dataArr addObject:model];
                }
                [classifyHisTable reloadData];
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
@end
