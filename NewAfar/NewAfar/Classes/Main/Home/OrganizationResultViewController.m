//
//  OrganizationResultViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/17.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "OrganizationResultViewController.h"
#import "OrganizationModel.h"
#import "FHeaderView.h"
#import "OrganInfoCell.h"
#import "OrganizationInfoViewController.h"

@interface OrganizationResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation OrganizationResultViewController
{
    NSString *query;
    NSMutableString *strM;
    UITableView *organizationTable;
    UIView *head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"机构查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
    [self sendRequestOrganizationData];
    //self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)initUI
{
    self.view.backgroundColor = BaseColor;
    
    organizationTable = [[UITableView alloc]initWithFrame:CGRectMake(0,NVHeight+40, ScreenWidth,ScreenHeight) style:UITableViewStyleGrouped];
    organizationTable.sectionFooterHeight = 1;
    organizationTable.sectionHeaderHeight = 0;
    organizationTable.rowHeight = 40;
    organizationTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    organizationTable.delegate = self;
    organizationTable.dataSource = self;
    [self.view addSubview:organizationTable];
    [organizationTable registerNib:[UINib nibWithNibName:@"OrganInfoCell" bundle:nil] forCellReuseIdentifier:@"organizationCell"];
    
    head =[[[NSBundle mainBundle]loadNibNamed:@"OrganInfoCell" owner:self options:nil] lastObject];
    head.backgroundColor = CellColor;
    [head setFrame:CGRectMake(0,NVHeight, ViewWidth, 40)];
    [self.view addSubview:head];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganInfoCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"organizationCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    OrganizationModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OrganizationDetailViewController *detail = StoryBoard(@"Data", @"organizationDetail");
//    OrganizationModel *model = _dataArr[indexPath.section];
//    detail.model = model;
//    PushController(detail)
    OrganizationInfoViewController *info = [[OrganizationInfoViewController alloc]init];
    OrganizationModel *model = _dataArr[indexPath.section];
    info.model = model;
    PushController(info)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestOrganizationData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *query1 = @"[c_id like '%%']";
    NSString *query2 = @"[c_name like '%%']";
    NSString *query3 = @"[c_id like '%%' and c_name like '%%']";
    if ([_organizationCode isEqualToString:@""]&&[_organizationName isEqualToString:@""]) {
        return;
    }else if (![_organizationCode isEqualToString:@""]&&[_organizationName isEqualToString:@""]){
        strM = [NSMutableString stringWithString:query1];
        NSRange range1 = [strM rangeOfString:@"c_id like '%"];
        [strM insertString:_organizationCode atIndex:range1.location+12];
    }else if ([_organizationCode isEqualToString:@""]&&![_organizationName isEqualToString:@""]){
        strM = [NSMutableString stringWithString:query2];
        NSRange range2 = [strM rangeOfString:@"c_name like '%"];
        [strM insertString:_organizationName atIndex:range2.location+14+_organizationCode.length];
    }else
    {
        strM = [NSMutableString stringWithString:query3];
        NSRange range1 = [strM rangeOfString:@"c_id like '%"];
        NSRange range2 = [strM rangeOfString:@"c_name like '%"];
        [strM insertString:_organizationCode atIndex:range1.location+12];
        [strM insertString:_organizationName atIndex:range2.location+14+_organizationCode.length];
    }
    
    NSString *str = @"<root><api><module>0302</module><type>0</type><query>%@</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,strM,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
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
                    OrganizationModel *model = [[OrganizationModel alloc]init];
                    if ([item elementsForName:@"c_id"].count>0) {
                        DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                        model.c_id = c_id.stringValue;
                    }else{
                        model.c_id = @"";
                    }
                    if ([item elementsForName:@"c_name"].count>0) {
                        DDXMLElement *c_name = [item elementsForName:@"c_name"][0];
                        model.c_name = c_name.stringValue;
                    }else{
                        model.c_name = @"";
                    }
                    if ([item elementsForName:@"dz"].count>0) {
                        DDXMLElement *dz = [item elementsForName:@"dz"][0];
                        model.dz = dz.stringValue;
                    }else{
                        model.dz = @"";
                    }
                    if ([item elementsForName:@"psjg"].count>0) {
                        DDXMLElement *psjg = [item elementsForName:@"psjg"][0];
                        model.psjg = psjg.stringValue;
                    }else{
                        model.psjg = @"";
                    }
                    if ([item elementsForName:@"fzr"].count>0) {
                        DDXMLElement *fzr = [item elementsForName:@"fzr"][0];
                        model.fzr = fzr.stringValue;
                    }else{
                        model.fzr = @"";
                    }
                    if ([item elementsForName:@"tel"].count>0) {
                        DDXMLElement *tel = [item elementsForName:@"tel"][0];
                        model.tel = tel.stringValue;
                    }else{
                        model.tel = @"";
                    }
                    if ([item elementsForName:@"lb"].count>0) {
                        DDXMLElement *lb = [item elementsForName:@"lb"][0];
                        model.lb = lb.stringValue;
                    }else{
                        model.lb = @"";
                    }
                    if ([item elementsForName:@"pszq"].count>0) {
                        DDXMLElement *pszq = [item elementsForName:@"pszq"][0];
                        model.pszq = pszq.stringValue;
                    }else{
                        model.pszq = @"";
                    }
                    [self.dataArr addObject:model];
                }
                [organizationTable reloadData];
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
