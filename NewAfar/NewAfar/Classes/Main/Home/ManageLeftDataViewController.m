//
//  ManageLeftDataViewController.m
//  NewAfar
//
//  Created by cw on 17/1/13.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "ManageLeftDataViewController.h"
#import "ManageHisModel.h"
#import "ManageLeftCell.h"

@interface ManageLeftDataViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation ManageLeftDataViewController
{
    UITableView *leftTable;
    UIView *head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"巡场记录" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestManageLeftData];
}
- (void)initUI{
    
    leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight+40, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    leftTable.delegate = self;
    leftTable.dataSource = self;
    leftTable.rowHeight = 40;
    leftTable.sectionHeaderHeight = 1;
    leftTable.sectionFooterHeight = 0;
    leftTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    leftTable.backgroundColor = BaseColor;
    [self.view addSubview:leftTable];
    leftTable.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [leftTable registerNib:[UINib nibWithNibName:@"ManageLeftCell" bundle:nil] forCellReuseIdentifier:@"manageLeftCell"];
    
    head =[[[NSBundle mainBundle]loadNibNamed:@"ManageLeftCell" owner:self options:nil] lastObject];
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
    ManageLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"manageLeftCell" forIndexPath:indexPath];
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
//查询结果数据
- (void)sendRequestManageLeftData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>1606</module><type>0</type><query>{bm=%@,tid=%@,zrr=%@,xcr=%@,s_dt=%@,e_dt=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,_depart,_type,_resP,_manP,_startD,_endD,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"],UUID];
    
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
                    DDXMLElement *rq = [item elementsForName:@"rq"][0];
                    model.rq = rq.stringValue;
                    DDXMLElement *date = [item elementsForName:@"date"][0];
                    model.date = date.stringValue;
                    DDXMLElement *name = [item elementsForName:@"name"][0];
                    model.name = name.stringValue;
                    DDXMLElement *zt = [item elementsForName:@"zt"][0];
                    model.zt = zt.stringValue;
                    [self.dataArr addObject:model];
                }
                [leftTable reloadData];
            }else
            {
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
