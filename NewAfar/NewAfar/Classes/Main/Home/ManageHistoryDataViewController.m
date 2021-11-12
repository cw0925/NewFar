//
//  ManageHistoryDataViewController.m
//  NewAfar
//
//  Created by cw on 17/1/13.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "ManageHistoryDataViewController.h"
#import "ManageHisModel.h"
#import "ManageHisCell.h"

@interface ManageHistoryDataViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation ManageHistoryDataViewController
{
    UITableView *resTable;
    UIView *head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"巡场记录" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestManageHistoryData];
}
- (void)initUI{
    resTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight+40, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    resTable.delegate = self;
    resTable.dataSource = self;
    resTable.rowHeight = 40;
    resTable.sectionFooterHeight = 0;
    resTable.sectionHeaderHeight = 1;
    resTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    resTable.backgroundColor = BaseColor;
    [self.view addSubview:resTable];
    resTable.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [resTable registerNib:[UINib nibWithNibName:@"ManageHisCell" bundle:nil] forCellReuseIdentifier:@"manageHisCell"];
    
    head =[[[NSBundle mainBundle]loadNibNamed:@"ManageHisCell" owner:self options:nil] lastObject];
    head.backgroundColor = CellColor;
    [head setFrame:CGRectMake(0,NavigationBarHeight, ViewWidth, 40)];
    [self.view addSubview:head];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManageHisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"manageHisCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    ManageHisModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
#pragma mark - 横屏
//- (BOOL)shouldAutorotate {
//    return YES;
//}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeRight;
//}
- (void)backPage
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendRequestManageHistoryData
{
    //<root><api><module>1603</module><type>0</type><query>{bm=101,tid=,zrr=,xcr=,s_dt=2017-01-01,e_dt=2017-12-31,page=1,size=10,type=1}</query></api><user><company>009105</company><customeruser>15939010676</customeruser><phoneno>lblblblblblbtt</phoneno></user></root>   历史巡场记录  后边加了type表示状态  1是已处理  0是未处理  2是全部
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>1603</module><type>0</type><query>{bm=%@,tid=%@,zrr=%@,xcr=%@,s_dt=%@,e_dt=%@,type=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_depart,_type,_resP,_manP,_startD,_endD,_state,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if ([element.stringValue isEqualToString:@"查询成功！"]) {
                head.hidden = NO;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ManageHisModel *model = [[ManageHisModel alloc]init];
                    DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                    model.c_id = c_id.stringValue;
                    DDXMLElement *bm = [item elementsForName:@"bm"][0];
                    model.bm = bm.stringValue;
                    DDXMLElement *type = [item elementsForName:@"type"][0];
                    model.type = type.stringValue;
                    DDXMLElement *zrr = [item elementsForName:@"zrr"][0];
                    model.zrr = zrr.stringValue;
                    DDXMLElement *cf = [item elementsForName:@"cf"][0];
                    model.cf = cf.stringValue;
                    DDXMLElement *date = [item elementsForName:@"date"][0];
                    model.date = date.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *zt = [item elementsForName:@"zt"][0];
                    model.zt = zt.stringValue;
                    [self.dataArr addObject:model];
                }
                [resTable reloadData];
            }else{
                head.hidden = YES;
                [self.view makeToast:element.stringValue];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
