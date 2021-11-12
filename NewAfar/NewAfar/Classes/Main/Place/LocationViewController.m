//
//  LocationViewController.m
//  NewAfar
//
//  Created by cw on 16/10/17.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "LocationViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>

#import <AMapSearchKit/AMapSearchKit.h>

#import "LocationCell.h"

#define GAODEKey @"a6d25bd89971096ad7d94e990f4ffea8"

@interface LocationViewController ()<AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic,strong)AMapSearchAPI  *search;
@property(nonatomic,copy)NSMutableArray *poiAnnotations;

@end

@implementation LocationViewController
{
    UITableView *locationTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"所在位置" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self getUserLocation];
    [self initUI];
}
- (void)initUI
{
    locationTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight) style:UITableViewStylePlain];
    locationTable.delegate = self;
    locationTable.dataSource = self;
    locationTable.rowHeight = 60;
    [self.view addSubview:locationTable];
    [locationTable registerNib:[UINib nibWithNibName:@"LocationCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [MBProgressHUD showMessag:@"正在定位..." toView:self.view];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _poiAnnotations.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AMapPOI *po = _poiAnnotations[indexPath.row];
    cell.title.font = [UIFont systemFontWithSize:14];
    cell.subtitle.font = [UIFont systemFontWithSize:12];
    cell.title.text = po.name;
    cell.subtitle.text = po.address;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *po = _poiAnnotations[indexPath.row];
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(po.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 反向传回位置信息
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getUserLocation
{
    //定位
    [AMapServices sharedServices].apiKey = GAODEKey;
    self.locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        //NSLog(@"定位：%@",regeocode);
        //搜索附近
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        
        request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        NSLog(@"%@",request.location);
        request.keywords            = @"电影院|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|政府机构及社会团体|公司企业|地名地址信息|道路附属设施";
        /* 按照距离排序. */
        request.sortrule            = 0;
        request.requireExtension    = YES;
        [self.search AMapPOIAroundSearch:request];
    }];
    
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    [_poiAnnotations addObjectsFromArray:response.pois];
    [locationTable reloadData];
   // NSLog(@"附近：%@",response.pois[0]);
    
    for (AMapPOI *item in response.pois) {
        NSLog(@"%@---%@--%@",item.name,item.address,item.businessArea);
    }
    
}
@end
