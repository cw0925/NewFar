//
//  GoodResultViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/16.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "GoodResultViewController.h"
#import "GoodModel.h"
#import "FHeaderView.h"
#import "GoodInfoCell.h"
//#import "GoodDetailViewController.h"
#import "GoodInfoViewController.h"

@interface GoodResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *stateArr;

@end

@implementation GoodResultViewController
{
    UITableView *goodTable;
    UIView *head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"商品列表" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestGoodInfoData];
}
- (void)backPage{
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}
- (void)initUI
{
    head =[[[NSBundle mainBundle]loadNibNamed:@"GoodInfoCell" owner:self options:nil] lastObject];
    head.backgroundColor = CellColor;
    [head setFrame:CGRectMake(0,NVHeight, ViewWidth, 40)];
    [self.view addSubview:head];
    
    self.view.backgroundColor = BaseColor;
    
    goodTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NVHeight+40, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    goodTable.delegate = self;
    goodTable.dataSource = self;
    goodTable.rowHeight = 40;
    goodTable.sectionHeaderHeight = 0;
    goodTable.sectionFooterHeight = 1;
    goodTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    [self.view addSubview:goodTable];
    [goodTable registerNib:[UINib nibWithNibName:@"GoodInfoCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    GoodModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GoodDetailViewController *detail = StoryBoard(@"Data", @"goodDetail");
//    GoodModel *model = _dataArr[indexPath.section];
//    detail.model = model;
//    PushController(detail)
    GoodInfoViewController *info = [[GoodInfoViewController alloc]init];
    GoodModel *model = _dataArr[indexPath.section];
    info.model = model;
    PushController(info)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//查询数据
- (void)sendRequestGoodInfoData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>0301</module><type>0</type><query>{store=%@,gcode=%@,barcode=%@,name=%@,pluno=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_store,_goodCode,_barcode,_goodName,_PLU,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    NSLog(@"%@",string);
    
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
         NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                head.hidden = YES;
                [self.view makeToast:element.stringValue];
                
            }else
            {
                head.hidden = NO;
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *element in rowArr) {
                     GoodModel *model = [[GoodModel alloc]init];
                    if ([element elementsForName:@"splb"].count>0) {
                        DDXMLElement *splb = [element elementsForName:@"splb"][0];
                        model.splb = splb.stringValue;
                    }else{
                        model.splb = @"";
                    }
                    if ([element elementsForName:@"lbmc"].count>0) {
                        DDXMLElement *lbmc = [element elementsForName:@"lbmc"][0];
                        model.lbmc = lbmc.stringValue;
                    }else{
                        model.lbmc = @"";
                    }
                    if ([element elementsForName:@"bm"].count>0) {
                        DDXMLElement *bm = [element elementsForName:@"bm"][0];
                        model.bm = bm.stringValue;
                    }else{
                        model.bm = @"";
                    }
                    if ([element elementsForName:@"bmmc"].count>0) {
                        DDXMLElement *bmmc = [element elementsForName:@"bmmc"][0];
                        model.bmmc = bmmc.stringValue;
                    }else{
                        model.bmmc = @"";
                    }
                    if ([element elementsForName:@"gys"].count>0) {
                        DDXMLElement *gys = [element elementsForName:@"gys"][0];
                        model.gys = gys.stringValue;
                    }else{
                        model.gys = @"";
                    }
                    if ([element elementsForName:@"gysmc"].count>0) {
                        DDXMLElement *gysmc = [element elementsForName:@"gysmc"][0];
                        model.gysmc = gysmc.stringValue;
                    }
                    if ([element elementsForName:@"pp"].count>0) {
                        DDXMLElement *pp = [element elementsForName:@"pp"][0];
                        model.pp = pp.stringValue;

                    }else{
                        model.pp = @"";
                    }
                    if ([element elementsForName:@"PPMC"].count>0) {
                        DDXMLElement *PPMC = [element elementsForName:@"PPMC"][0];
                        model.PPMC = PPMC.stringValue;
                    }else{
                        model.PPMC = @"";
                    }
                    if ([element elementsForName:@"gcode"].count>0) {
                        DDXMLElement *gcode = [element elementsForName:@"gcode"][0];
                        model.gcode = gcode.stringValue;
                    }else{
                        model.gcode = @"";
                    }
                    if ([element elementsForName:@"code"].count>0) {
                        DDXMLElement *code = [element elementsForName:@"code"][0];
                        model.code = code.stringValue;
                    }else{
                        model.code = @"";
                    }
                    if ([element elementsForName:@"barcode"].count>0) {
                        DDXMLElement *barcode = [element elementsForName:@"barcode"][0];
                        model.barcode = barcode.stringValue;
                    }else{
                        model.barcode = @"";
                    }
                    if ([element elementsForName:@"gg"].count>0) {
                        DDXMLElement *gg = [element elementsForName:@"gg"][0];
                        model.gg = gg.stringValue;
                    }else{
                        model.gg = @"";
                    }
                    if ([element elementsForName:@"cd"].count>0) {
                        DDXMLElement *cd = [element elementsForName:@"cd"][0];
                        model.cd = cd.stringValue;
                    }else{
                        model.cd = @"";
                    }
                    if ([element elementsForName:@"cdmc"].count>0) {
                        DDXMLElement *cdmc = [element elementsForName:@"cdmc"][0];
                        model.cdmc = cdmc.stringValue;
                    }else{
                        model.cdmc = @"";
                    }
                    if ([element elementsForName:@"xsdw"].count>0) {
                        DDXMLElement *xsdw = [element elementsForName:@"xsdw"][0];
                        model.xsdw = xsdw.stringValue;
                    }else{
                        model.xsdw = @"";
                    }
                    if ([element elementsForName:@"jhdw"].count>0) {
                        DDXMLElement *jhdw = [element elementsForName:@"jhdw"][0];
                        model.jhdw = jhdw.stringValue;
                    }else{
                        model.jhdw = @"";
                    }
                    if ([element elementsForName:@"lsj"].count>0) {
                        DDXMLElement *lsj = [element elementsForName:@"lsj"][0];
                        model.lsj = lsj.stringValue;
                    }else{
                        model.lsj = @"";
                    }
                    if ([element elementsForName:@"hyj"].count>0) {
                        DDXMLElement *hyj = [element elementsForName:@"hyj"][0];
                        model.hyj = hyj.stringValue;
                    }else{
                        model.hyj = @"";
                    }
                    if ([element elementsForName:@"zkj"].count>0) {
                        DDXMLElement *zkj = [element elementsForName:@"zkj"][0];
                        model.zkj = zkj.stringValue;
                    }else{
                        model.zkj = @"";
                    }
                    if ([element elementsForName:@"pfj"].count>0) {
                        DDXMLElement *pfj = [element elementsForName:@"pfj"][0];
                        model.pfj = pfj.stringValue;
                    }else{
                        model.pfj = @"";
                    }
                    if ([element elementsForName:@"cur_number"].count>0) {
                        DDXMLElement *cur_number = [element elementsForName:@"cur_number"][0];
                        model.cur_number = cur_number.stringValue;
                    }else{
                        model.cur_number = @"";
                    }
                    if ([element elementsForName:@"sale_number"].count>0) {
                        DDXMLElement *sale_number = [element elementsForName:@"sale_number"][0];
                        model.sale_number = sale_number.stringValue;
                    }else{
                        model.sale_number = @"";
                    }
                    if ([element elementsForName:@"cur_rec"].count>0) {
                        DDXMLElement *cur_rec = [element elementsForName:@"cur_rec"][0];
                        model.cur_rec = cur_rec.stringValue;
                    }else{
                        model.cur_rec = @"";
                    }
                    if ([element elementsForName:@"last_saleday"].count>0) {
                        DDXMLElement *last_saleday = [element elementsForName:@"last_saleday"][0];
                        model.last_saleday = last_saleday.stringValue;
                    }else{
                        model.last_saleday = @"";
                    }
                    if ([element elementsForName:@"jj"].count>0) {
                        DDXMLElement *jj = [element elementsForName:@"jj"][0];
                        model.jj = jj.stringValue;
                    }else{
                        model.jj = @"";
                    }
                    [self.dataArr addObject:model];
                }
                [goodTable reloadData];
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
