//
//  RealTimeViewController.m
//  NewAfar
//
//  Created by cw on 17/3/21.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "RealTimeViewController.h"
#import "MonitorModel.h"
#import "RealControlCell.h"
#import "DayAxisValueFormatter.h"
#import "AxisValueFormatter.h"

#define BtnW (ViewWidth-30)/2

@interface RealTimeViewController ()<UITableViewDelegate,UITableViewDataSource,ChartViewDelegate>

@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UITableView *dataTable;
@property(nonatomic,copy)NSMutableArray *dataArr;

@property (nonatomic, strong) BarChartView *barChartView;
@property(nonatomic,copy)NSMutableArray *valueArr;
@property(nonatomic,copy)NSMutableArray *descArr;
@property(nonatomic,copy)NSMutableArray *nameArr;

@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)UILabel *tipLabel;
@end

@implementation RealTimeViewController
{
    UIView *head;
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"实时监测查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    self.view.backgroundColor = BaseColor;
    [self.view addSubview:self.backgroundView];
    
    [self sendRequestRealMonitorData];
}
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,NVHeight, ViewWidth, 55)];
        _backgroundView.backgroundColor = BaseColor;
        NSArray *arr = @[@"数据",@"图形"];
        for (NSInteger i=0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.frame = CGRectMake(10*(i+1)+BtnW*i, 10, BtnW, 35);
            btn.tag = i+1;
            btn.titleLabel.font = [UIFont systemFontWithSize:14];
            [btn setBackgroundImage:[UIImage imageNamed:@"bg_regist"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(showViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [_backgroundView addSubview:btn];
            if (btn.tag == 1) {
                btn.selected = YES;
                [self.view addSubview:self.dataTable];
            }
        }
    }
    return _backgroundView;
}
- (void)showViewClick:(UIButton *)sender{
    //处理按钮的背景切换
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+1];
        btn.selected = NO;
    }
    sender.selected = YES;
    switch (sender.tag) {
        case 1://数据列表
        {
            if (self.dataArr.count<=0) {
                head.hidden = YES;
            }
            if (_barChartView) {
                _barChartView.hidden = YES;
                self.totalLabel.hidden = YES;
                self.tipLabel.hidden = YES;
            }
            _dataTable.hidden = NO;
            head.hidden = NO;
        }
            break;
        case 2://柱状图
        {
            if (self.dataArr.count<=0) {
                head.hidden = YES;
            }
            if (_dataTable||head) {
                _dataTable.hidden = YES;
                head.hidden = YES;
            }
            if (!_barChartView) {
                [self.view addSubview:self.barChartView];
            }
            _barChartView.hidden = NO;
            self.totalLabel.hidden = NO;
            self.tipLabel.hidden = NO;
        }
            break;
        default:
            break;
    }
}
#pragma mark - 数据
- (UITableView *)dataTable{
    if (!_dataTable) {
        head =[[[NSBundle mainBundle]loadNibNamed:@"RealControlCell" owner:self options:nil] lastObject];
        head.backgroundColor = CellColor;
        [head setFrame:CGRectMake(0,CGRectGetMaxY(_backgroundView.frame), ViewWidth, 40)];
        [self.view addSubview:head];
        
        _dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(head.frame), ViewWidth, ViewHeight-CGRectGetMaxY(head.frame)) style:UITableViewStyleGrouped];
        _dataTable.delegate = self;
        _dataTable.dataSource = self;
        _dataTable.sectionFooterHeight = 0;
        _dataTable.sectionHeaderHeight = 1;
        _dataTable.rowHeight = 40;
        _dataTable.backgroundColor = BaseColor;
        [self.view addSubview:_dataTable];
        [_dataTable registerNib:[UINib nibWithNibName:@"RealControlCell" bundle:nil] forCellReuseIdentifier:@"controlCell"];
        
        UIView *tableHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
        tableHead.backgroundColor = BaseColor;
        _dataTable.tableHeaderView = tableHead;
    }
    return _dataTable;
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
- (BarChartView *)barChartView{
    if (!_barChartView) {
        _barChartView = [[BarChartView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(self.backgroundView.frame)+50, ScreenWidth-40, 300)];
        _barChartView.delegate = self;
        
        _barChartView.drawBarShadowEnabled = NO;
        _barChartView.drawValueAboveBarEnabled = YES;
        
        _barChartView.maxVisibleCount = 60;
        
        ChartXAxis *xAxis = _barChartView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.granularity = 1.0; // only intervals of 1 day
        xAxis.labelCount = 7;
        
        AxisValueFormatter *xFormatter = [[AxisValueFormatter alloc]initForChart:_barChartView];
        xFormatter.xArray = self.nameArr;
        xAxis.valueFormatter = xFormatter;
        
        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
        leftAxisFormatter.minimumFractionDigits = 0;
        leftAxisFormatter.maximumFractionDigits = 1;
//        leftAxisFormatter.negativeSuffix = @" $";
//        leftAxisFormatter.positiveSuffix = @" $";
        
        ChartYAxis *leftAxis = _barChartView.leftAxis;
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
        leftAxis.labelCount = 8;
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        leftAxis.spaceTop = 0.15;
        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        
        ChartYAxis *rightAxis = _barChartView.rightAxis;
        rightAxis.enabled = NO;
        
        ChartLegend *l = _barChartView.legend;
        l.enabled = NO;
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(_barChartView.frame)+10, ScreenWidth-100, 30)];
        if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
            tipLabel.text = @"y轴:净收款额（单位：万元）";
        }else{
            tipLabel.text = @"y轴:净收款额（单位：元）";
        }
        tipLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:tipLabel];
        self.tipLabel = tipLabel;
        
        UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(tipLabel.frame), ScreenWidth-100, 90)];
        totalLabel.font = [UIFont systemFontOfSize:12];
        totalLabel.numberOfLines = 0;
        [self.view addSubview:totalLabel];
        self.totalLabel = totalLabel;
        
        [self setData];
    }
    return _barChartView;
}
- (void)setData
{
    double start = 0;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = start; i < self.dataArr.count-1; i++)
    {
        MonitorModel *model = self.dataArr[i];
        double val = 0.00;
        if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
            val = [model.sjsale doubleValue]/10000.0;
        }else{
            val = [model.sjsale doubleValue];
        }
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val]];
    }
    
    BarChartDataSet *set1 = nil;
    if (_barChartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_barChartView.data.dataSets[0];
        [set1 replaceEntries: yVals];
        [_barChartView.data notifyDataChanged];
        [_barChartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithEntries:yVals label:@"2019"];
        [set1 setColors:ChartColorTemplates.material];
        set1.drawIconsEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        data.barWidth = 0.9f;
        
        _barChartView.data = data;
        
        MonitorModel *lastModel = [self.dataArr lastObject];
        
        if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
            self.totalLabel.text = [NSString stringWithFormat:@"合计：\n净收款额：%.02f万元\n成        本：%.02f万元\n毛  利  率：%.02f%%",[lastModel.sjsale doubleValue]/10000.0,[lastModel.cb doubleValue]/10000.0,[lastModel.mll doubleValue]*100];
        }else{
            self.totalLabel.text = [NSString stringWithFormat:@"合计：\n净收款额：%.02f元\n成        本：%.02f元\n毛  利  率：%.02f%%",[lastModel.sjsale doubleValue],[lastModel.cb doubleValue],[lastModel.mll doubleValue]*100];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//查询数据
- (void)sendRequestRealMonitorData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>0601</module><type>0</type><query>{store=%@,dt=%@,len=%@}</query></api><user><company>%@</company><customeruser>%@</customeruser></user></root>";
    NSString *string = [NSString stringWithFormat:str,_code,_date,_length,[userDefault valueForKey:@"qyno"],[userDefault valueForKey:@"name"]];
    
    [NetRequest sendRequest:FirstBaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        NSLog(@"%@",doc);
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功"]) {
                head.hidden = YES;
                _backgroundView.hidden = YES;
                [self.view makeToast:element.stringValue];
                for (UIView *view in _backgroundView.subviews) {
                    if ([view isMemberOfClass:[UIButton class]]) {
                        UIButton *btn = (UIButton *)view;
                        btn.enabled = NO;
                    }
                }
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
                    [self.nameArr addObject:model.name];
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
                [_dataTable reloadData];
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
- (NSMutableArray *)valueArr
{
    if (!_valueArr) {
        _valueArr = [NSMutableArray array];
    }
    return _valueArr;
}
- (NSMutableArray *)descArr
{
    if (!_descArr) {
        _descArr = [NSMutableArray array];
    }
    return _descArr;
}
- (NSMutableArray *)nameArr
{
    if (!_nameArr) {
        _nameArr = [NSMutableArray array];
    }
    return _nameArr;
}
@end
