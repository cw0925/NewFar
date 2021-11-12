//
//  RealDataViewController.m
//  NewAfar
//
//  Created by cw on 17/1/13.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "RealDataViewController.h"
#import "MonitorModel.h"
#import "RealControlCell.h"

@interface RealDataViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation RealDataViewController
{
    UITableView *monitorTable;
    UIView *head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BaseColor;
    [self initUI];
    [self sendRequestRealMonitorData];
}
- (void)initUI
{
    monitorTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 6, ViewWidth, ViewHeight) style:UITableViewStyleGrouped];
    monitorTable.delegate = self;
    monitorTable.dataSource = self;
    monitorTable.sectionFooterHeight = 0;
    monitorTable.sectionHeaderHeight = 1;
    monitorTable.backgroundColor = BaseColor;
    [self.view addSubview:monitorTable];
    [monitorTable registerNib:[UINib nibWithNibName:@"RealControlCell" bundle:nil] forCellReuseIdentifier:@"controlCell"];
    
    head =[[[NSBundle mainBundle]loadNibNamed:@"RealControlCell" owner:self options:nil] lastObject];
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
    RealControlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"controlCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    MonitorModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//查询数据
- (void)sendRequestRealMonitorData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>0601</module><type>0</type><query>{store=%@,dt=%@,len=0}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_code,_date,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
         NSLog(@"%@",doc);
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                if (_dataArr.count >0) {
                    [_dataArr removeAllObjects];
                    [monitorTable reloadData];
                }
                head.hidden = YES;
                [self.view makeToast:element.stringValue];
            }else
            {
                head.hidden = NO;
                NSArray *dataArr = [doc nodesForXPath:@"//row" error:nil];
                //NSLog(@"%@",doc);
                for (DDXMLElement *element in dataArr) {
                    MonitorModel *model = [[MonitorModel alloc]init];
                    if ([element elementsForName:@"name"].count>0) {
                        DDXMLElement *name = [element elementsForName:@"name"][0];
                        model.name = name.stringValue;
                    }else{
                        model.name = @"";
                    }
                    if ([element elementsForName:@"cb"].count>0) {
                        DDXMLElement *cb = [element elementsForName:@"cb"][0];
                        model.cb = cb.stringValue;
                    }else{
                        model.cb = @"";
                    }
                    if ([element elementsForName:@"sale"].count>0) {
                        DDXMLElement *sale = [element elementsForName:@"sale"][0];
                        model.sale = sale.stringValue;
                    }else{
                        model.sale = @"";
                    }
                    if ([element elementsForName:@"sjsale"].count>0) {
                        DDXMLElement *sjsale = [element elementsForName:@"sjsale"][0];
                        model.sjsale = sjsale.stringValue;
                    }else{
                        model.sjsale = @"";
                    }
                    if ([element elementsForName:@"ZB"].count>0) {
                        DDXMLElement *ZB = [element elementsForName:@"ZB"][0];
                        model.ZB = ZB.stringValue;
                    }else{
                        model.ZB = @"";
                    }
                    if ([element elementsForName:@"ml"].count>0) {
                        DDXMLElement *ml = [element elementsForName:@"ml"][0];
                        model.ml = ml.stringValue;
                    }else{
                        model.ml = @"";
                    }
                    if ([element elementsForName:@"mll"].count>0) {
                        DDXMLElement *mll = [element elementsForName:@"mll"][0];
                        model.mll = mll.stringValue;
                    }else{
                        model.mll = @"";
                    }
                    if ([element elementsForName:@"bm"].count>0) {
                        DDXMLElement *bm = [element elementsForName:@"bm"][0];
                        model.bm = bm.stringValue;
                    }else{
                        model.bm = @"";
                    }
                    [self.dataArr addObject:model];
                }
                [monitorTable reloadData];
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
