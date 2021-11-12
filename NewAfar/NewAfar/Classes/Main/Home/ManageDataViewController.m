//
//  ManageDataViewController.m
//  NewAfar
//
//  Created by cw on 17/1/13.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "ManageDataViewController.h"
#import "ManagerModel.h"
#import "ManageViewCell.h"

@interface ManageDataViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation ManageDataViewController
{
    UITableView *detailTable;
    UIView *head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = BaseColor;
    [self initUI];
    [self sendRequestManagerData];
}
- (void)initUI{
    detailTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    detailTable.delegate = self;
    detailTable.dataSource = self;
    detailTable.sectionFooterHeight = 0;
    detailTable.sectionHeaderHeight = 1;
    detailTable.backgroundColor = BaseColor;
    [self.view addSubview:detailTable];
    
    [detailTable registerNib:[UINib nibWithNibName:@"ManageViewCell" bundle:nil] forCellReuseIdentifier:@"managerCell"];
    
    head =[[[NSBundle mainBundle]loadNibNamed:@"ManageViewCell" owner:self options:nil] lastObject];
    head.backgroundColor = CellColor;
    [head setFrame:CGRectMake(0,0, ViewWidth, 40)];
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
    ManageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ManagerModel *model = _dataArr[indexPath.section];
    [cell configCell:model];    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 数据列表数据 type 1：总过程 2：销售趋势 3：来客数趋势
- (void)sendRequestManagerData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    //<root><api><module>0602</module><type>0</type><query>{type=1,store=102,dt=2016-2-4,end=2017-02-04}</query></api><user><company>009105</company><customeruser>15939010676</customeruser></user></root>
    NSString *str = @"<root><api><module>0602</module><type>0</type><query>{type=1,store=%@,dt=%@,end=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    
    NSString *string = [NSString stringWithFormat:str,_code,_date,_endDate,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                head.hidden = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                //return ;
            }else{
                head.hidden = NO;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ManagerModel *model = [[ManagerModel alloc]init];
                    if ([item elementsForName:@"date"].count>0) {
                        DDXMLElement *date = [item elementsForName:@"date"][0];
                        model.date = date.stringValue;
                    }else{
                        model.date = @"";
                    }
                    if ([item elementsForName:@"bqxs"].count>0) {
                        DDXMLElement *bqxs = [item elementsForName:@"bqxs"][0];
                        model.bqxs = bqxs.stringValue;
                    }else{
                        model.bqxs = @"";
                    }
                    if ([item elementsForName:@"sqxs"].count>0) {
                        DDXMLElement *sqxs = [item elementsForName:@"sqxs"][0];
                        model.sqxs = sqxs.stringValue;
                    }else{
                        model.sqxs = @"";
                    }
                    if ([item elementsForName:@"xshb"].count>0) {
                        DDXMLElement *xshb = [item elementsForName:@"xshb"][0];
                        model.xshb = xshb.stringValue;
                    }else{
                        model.xshb = @"";
                    }
                    if ([item elementsForName:@"bqcustomers"].count>0) {
                        DDXMLElement *bqcustomers = [item elementsForName:@"bqcustomers"][0];
                        model.bqcustomers = bqcustomers.stringValue;
                    }else{
                        model.bqcustomers = @"";
                    }
                    if ([item elementsForName:@"sqcustomers"].count>0) {
                        DDXMLElement *sqcustomers = [item elementsForName:@"sqcustomers"][0];
                        model.sqcustomers = sqcustomers.stringValue;
                    }else{
                        model.sqcustomers = @"";
                    }
                    if ([item elementsForName:@"customerhb"].count>0) {
                        DDXMLElement *customerhb = [item elementsForName:@"customerhb"][0];
                        model.customerhb = customerhb.stringValue;
                    }else{
                        model.customerhb = @"";
                    }
                    [self.dataArr addObject:model];
                }
                [detailTable reloadData];                //刷新
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
    } failure:^(NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
