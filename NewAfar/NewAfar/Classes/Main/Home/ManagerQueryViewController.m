//
//  ManagerQueryViewController.m
//  NewAfar
//
//  Created by afarsoft on 2018/2/24.
//  Copyright © 2018年 afarsoft. All rights reserved.
//

#import "ManagerQueryViewController.h"
#import "ManagerModel.h"
#import "ManageViewCell.h"


#define BtnW (ViewWidth-40)/3

@interface ManagerQueryViewController ()<UITableViewDelegate,UITableViewDataSource,ChartViewDelegate>

@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UITableView *dataTable;

@property(nonatomic,copy)NSMutableArray *lineSaleArr;
@property (nonatomic, strong) LineChartView *LineChartView;
@property (nonatomic, strong) LineChartData *data;


@end

@implementation ManagerQueryViewController{
    ManageViewCell *head;
    UILabel *legendLabel;
    BOOL isCustomer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"店长视图查询" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    self.view.backgroundColor = BaseColor;
    [self.view addSubview:self.backgroundView];
    [self sendRequestManagerData];
    isCustomer = NO;
}
- (UIView *)backgroundView{
    if (!_backgroundView) {
        NSArray *arr = @[@"数据列表",@"销售额趋势",@"来客数趋势"];
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,NVHeight, ViewWidth, 55)];
        //headView.backgroundColor = [UIColor redColor];
        for (NSInteger i=0; i<3; i++) {
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
    for (NSInteger i=0; i<3; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i+1];
        btn.selected = NO;
    }
    sender.selected = YES;
    
    switch (sender.tag) {
        case 1:
        {
            _dataTable.hidden = NO;
            head.hidden = NO;
            if (_LineChartView||legendLabel) {
                [_LineChartView removeFromSuperview];
                [legendLabel removeFromSuperview];
            }
            [_dataTable reloadData];
            isCustomer = NO;
        }
            break;
        case 2:
        {
            if (_LineChartView) {
                [_LineChartView removeFromSuperview];
            }
            _dataTable.hidden = YES;
            head.hidden = YES;
            isCustomer = NO;
            [self sendRequestSaleTrendData];
        }
            break;
        case 3:
        {
            if (_LineChartView) {
                [_LineChartView removeFromSuperview];
            }
            _dataTable.hidden = YES;
            head.hidden = YES;
            isCustomer = YES;
            [self sendRequestCustomerData];
        }
            break;
        default:
            break;
    }
}
- (UITableView *)dataTable
{
    if (!_dataTable) {
        head =[[[NSBundle mainBundle]loadNibNamed:@"ManageViewCell" owner:self options:nil] lastObject];
        head.backgroundColor = CellColor;
        [head setFrame:CGRectMake(0,CGRectGetMaxY(_backgroundView.frame), ViewWidth, 40)];
        if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
            head.bs.text = @"销售额(万元)";
        }else{
            head.bs.text = @"销售额(元)";
        }
        [self.view addSubview:head];
        
        _dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(head.frame), ViewWidth, ViewHeight-CGRectGetMaxY(_backgroundView.frame)) style:UITableViewStyleGrouped];
        _dataTable.delegate = self;
        _dataTable.dataSource = self;
        _dataTable.rowHeight = 40;
        _dataTable.sectionFooterHeight = 0;
        _dataTable.sectionHeaderHeight = 1;
        _dataTable.backgroundColor = BaseColor;
        
        [_dataTable registerNib:[UINib nibWithNibName:@"ManageViewCell" bundle:nil] forCellReuseIdentifier:@"managerCell"];
        
        UIView *tableHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.1)];
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
    ManageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ManagerModel *model = _dataArr[indexPath.section];
    [cell configCell:model];
    return cell;
}
#pragma mark - 绘制折线图
- (void)drawupLineChart
{
    _LineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(20, NVHeight+70, ViewWidth-40, ViewHeight-NVHeight-150)];
    [self.view addSubview:_LineChartView];
    _LineChartView.delegate = self;
    
    _LineChartView.chartDescription.enabled = NO;
    
    _LineChartView.dragEnabled = YES;
    [_LineChartView setScaleEnabled:YES];
    _LineChartView.pinchZoomEnabled = YES;
    _LineChartView.drawGridBackgroundEnabled = NO;
//    X轴
    _LineChartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
    _LineChartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    _LineChartView.xAxis.gridLineDashPhase = 0.f;
    _LineChartView.xAxis.drawGridLinesEnabled = NO;//不绘制网格线
//    Y轴
    ChartYAxis *leftAxis = _LineChartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
    leftAxis.axisMinimum = 0.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = YES;
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    
    _LineChartView.rightAxis.enabled = NO;
    
    _LineChartView.legend.form = ChartLegendFormLine;
    
    [self setData];
    
    [_LineChartView animateWithXAxisDuration:2.5];
   
}

//为折线图设置数据
- (void)setData
{
    //    x轴数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.lineSaleArr.count; i++) {
        ManagerModel *model = self.lineSaleArr[i];
        NSString *date = [model.date componentsSeparatedByString:@"T"][0];
        [xVals addObject:date];
        NSLog(@"%@",xVals);
    }
    _LineChartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc]initWithValues:xVals];
   //    y轴数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.lineSaleArr.count; i++)
    {
        ManagerModel *model = self.lineSaleArr[i];
        double yData = 0.00;
        if (isCustomer) {
            yData = [model.money doubleValue];
        }else{
            if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
                yData = [model.money doubleValue]/10000.0;
            }else{
                yData = [model.money doubleValue];
            }
        }
        ChartDataEntry *entry = [[ChartDataEntry alloc]initWithX:i y:yData];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = nil;
    if (_LineChartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_LineChartView.data.dataSets[0];
//        set1.values = yVals;
        [set1 replaceEntries: yVals];
        [_LineChartView.data notifyDataChanged];
        [_LineChartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:yVals label:@""];
//        set1 = [[LineChartDataSet alloc] initWithValues:yVals label:@""];
        
        set1.drawIconsEnabled = NO;
        
        set1.lineDashLengths = @[@5.f, @2.5f];
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
//        折线颜色
        [set1 setColor:[self colorWithHexString:@"#007FFF"]];
//        点的颜色
        [set1 setCircleColor:UIColor.redColor];
        set1.lineWidth = 1.0/[UIScreen mainScreen].scale;//折线宽度
        set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        set1.drawCirclesEnabled = YES;//是否绘制拐点
        set1.circleRadius = 4.0;
        set1.circleHoleRadius = 2.0;
        set1.drawCircleHoleEnabled = YES;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        set1.drawFilledEnabled = YES;//是否填充颜色
        //点击选中拐点的交互样式
        set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
        set1.highlightColor = [self colorWithHexString:@"#c83c23"];//点击选中拐点的十字线的颜色
        set1.highlightLineWidth = 1.0/[UIScreen mainScreen].scale;//十字线宽度
        set1.highlightLineDashLengths = @[@5, @5];//十字线的虚线样式
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 0.3f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        _LineChartView.data = data;
    }
}
//- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
//{
//    return [NSString stringWithFormat:@"周%.0f",value];
//}
//将十六进制颜色转换为 UIColor 对象
- (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}
//图例
- (void)showPicExample:(NSString *)string
{
    if (legendLabel) {
        [legendLabel removeFromSuperview];
    }
    legendLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.LineChartView.frame)-30, ViewWidth-20, 40)];
    legendLabel.backgroundColor = [UIColor clearColor];
    legendLabel.text = string;
    [self.view addSubview:legendLabel];
    legendLabel.textAlignment = NSTextAlignmentCenter;
    legendLabel.font = [UIFont systemFontOfSize:12];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 数据列表数据 type 1：总过程 2：销售趋势 3：来客数趋势
- (void)sendRequestManagerData//1
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
                self.backgroundView.hidden = YES;
                head.hidden = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
            }else{
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
                [_dataTable reloadData];//刷新
            }
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)sendRequestSaleTrendData//2
{
    if (self.lineSaleArr.count>0) {
        [_lineSaleArr removeAllObjects];
    }
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
                self.backgroundView.hidden = YES;
                head.hidden = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
            }else{
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
                        model.money = bqxs.stringValue;
                    }else{
                        model.money = @"";
                    }
                    [self.lineSaleArr addObject:model];
                }
                [self drawupLineChart];
                if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
                    [self showPicExample:@"x轴：日期  y轴：销售额(单位：万元)"];
                }else{
                    [self showPicExample:@"x轴：日期  y轴：销售额(单位：元)"];
                }
            }
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)sendRequestCustomerData//3
{
    if (self.lineSaleArr.count>0) {
        [_lineSaleArr removeAllObjects];
    }
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
                self.backgroundView.hidden = YES;
                head.hidden = YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    ManagerModel *model = [[ManagerModel alloc]init];
                    if ([item elementsForName:@"date"].count>0) {
                        DDXMLElement *date = [item elementsForName:@"date"][0];
                        model.date = date.stringValue;
                    }else{
                        model.date = @"";
                    }
                    if ([item elementsForName:@"bqcustomers"].count>0) {
                        DDXMLElement *bqcustomers = [item elementsForName:@"bqcustomers"][0];
                        model.money = bqcustomers.stringValue;
                    }else{
                        model.money = @"";
                    }
                    [self.lineSaleArr addObject:model];
                }
                [self drawupLineChart];
                [self showPicExample:@"x轴：日期 y轴：来客数"];
            }
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
- (NSMutableArray *)lineSaleArr
{
    if (!_lineSaleArr) {
        _lineSaleArr = [NSMutableArray array];
    }
    return _lineSaleArr;
}
@end
