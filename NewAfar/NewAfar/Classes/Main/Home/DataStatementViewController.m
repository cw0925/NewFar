//
//  DataStatementViewController.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/22.
//  Copyright © 2016年 CW. All rights reserved.
//
#import "DataStatementViewController.h"
#import "HomeCollectionCell.h"
#import "SectionHeaderView.h"
#import "SaleDataQueryViewController.h"
#import "GoodViewController.h"
#import "OrganizationViewController.h"
#import "PromotionRatioViewController.h"
#import "PromotionCheckViewController.h"
#import "GoodSaleViewController.h"
#import "RealMonitorViewController.h"
#import "ManagerViewController.h"
#import "SupplierViewController.h"
#import "PayListViewController.h"

#import "ListModel.h"

@interface DataStatementViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation DataStatementViewController
{
    UICollectionView *homeCollection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"报表中心" hasLeft:YES hasRight:NO withRightBarButtonItemImage:nil];
    
    [self createUI];
    [self initData];
}
- (void)createUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;//最小行间距(当垂直布局时是行间距，当水平布局时可以理解为列间距)
    layout.minimumInteritemSpacing = 10;//两个单元格之间的最小间距
    homeCollection = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    homeCollection.delegate = self;
    homeCollection.dataSource = self;
    //homeCollection.scrollEnabled = NO;
    homeCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:homeCollection];
    [homeCollection registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"homeCell"];
    [homeCollection registerNib:[UINib nibWithNibName:@"SectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}
//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 30,0, 30);
}
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ViewWidth-40)/4,(ViewWidth-40)/4+20);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCell" forIndexPath:indexPath];
    cell.title.font = [UIFont systemFontWithSize:13];
    ListModel *model = _dataArr[indexPath.item];
    cell.title.text = model.title;
    cell.pic.image = [UIImage imageNamed:model.icon];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = _dataArr[indexPath.item];
    if ([model.title isEqualToString:@"销售查询"]) {
        SaleDataQueryViewController *sale = StoryBoard(@"Data", @"sale")
        PushController(sale)
    }else if ([model.title isEqualToString:@"付款统计"]){
        PayListViewController *pay = StoryBoard(@"Data", @"pay");
        PushController(pay)
    }else if ([model.title isEqualToString:@"实时监测"]){
        RealMonitorViewController *monitor = StoryBoard(@"Data", @"monitor")
        PushController(monitor)
    }else if ([model.title isEqualToString:@"店长视图"]){
        ManagerViewController *manager = StoryBoard(@"Data", @"manager")
        PushController(manager)
    }else if ([model.title isEqualToString:@"商品查询"]){
        GoodViewController *good = StoryBoard(@"Data", @"good")
        PushController(good)
    }else if ([model.title isEqualToString:@"机构查询"]){
        OrganizationViewController *organization = StoryBoard(@"Data", @"organization")
        PushController(organization)
    }
}
- (void)initData{
    
    NSArray *arr = @[[NSNumber numberWithBool:[userDefault boolForKey:@"xscx"]],
                     [NSNumber numberWithBool:[userDefault boolForKey:@"fktj"]],
                     [NSNumber numberWithBool:[userDefault boolForKey:@"ssjc"]],
                     [NSNumber numberWithBool:[userDefault boolForKey:@"dzst"]],
                     [NSNumber numberWithBool:[userDefault boolForKey:@"spcx"]],
                     [NSNumber numberWithBool:[userDefault boolForKey:@"jgcx"]]];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ListModel *model = [[ListModel alloc]init];
        if (idx == 0) {
            if ([obj boolValue]) {
                model.title = @"销售查询";
                model.icon = @"salequery";
            }else{
                model.title = @"";
                model.icon = @"";
            }

        }else if(idx == 1){
            if ([obj boolValue]) {
                model.title = @"付款统计";
                model.icon = @"pay";
            }else{
                model.title = @"";
                model.icon = @"";
            }

        }else if(idx == 2){
            if ([obj boolValue]) {
                model.title = @"实时监测";
                model.icon = @"RT";
            }else{
                model.title = @"";
                model.icon = @"";
            }

        }else if(idx == 3){
            if ([obj boolValue]) {
                model.title = @"店长视图";
                model.icon = @"manager";
            }else{
                model.title = @"";
                model.icon = @"";
            }

        }else if(idx == 4){
            if ([obj boolValue]) {
                model.title = @"商品查询";
                model.icon = @"goodquery";
            }else{
                model.title = @"";
                model.icon = @"";
            }

        }else if(idx == 5){
            if ([obj boolValue]) {
                model.title = @"机构查询";
                model.icon = @"organizationquery";
            }else{
                model.title = @"";
                model.icon = @"";
            }

        }
        [self.dataArr addObject:model];
        
        if (stop) {
            for (ListModel *model in self.dataArr) {
                if ([model.title isEqualToString:@""]) {
                    [self.dataArr removeObject:model];
                }
            }
            [homeCollection reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
