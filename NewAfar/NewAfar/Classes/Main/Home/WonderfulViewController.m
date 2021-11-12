//
//  WonderfulViewController.m
//  NewAfar
//
//  Created by cw on 17/2/24.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "WonderfulViewController.h"
#import "JKRFallsLayout.h"
#import "WorkplaceModel.h"
#import "WonderfulCell.h"

#define SIZE 100

@interface WonderfulViewController ()<JKRFallsLayoutDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,assign)NSInteger allPage;

@end

@implementation WonderfulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"精彩分享" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self sendRequestShareData:1];
}
- (void)initUI{
    JKRFallsLayout *fallsLayout = [[JKRFallsLayout alloc] init];
    fallsLayout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:fallsLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.dataSource = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"WonderfulCell" bundle:nil] forCellWithReuseIdentifier:@"collectioncell"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WonderfulCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    WorkplaceModel *model = _dataArr[indexPath.item];
    [cell configCell:model];
    return cell;
}
/// 列数
- (CGFloat)columnCountInFallsLayout:(JKRFallsLayout *)fallsLayout{
    return 2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequestShareData:(NSInteger)page
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    
    NSString *str = @"<root><api><module>1201</module><type>0</type><query>{type=0,page=%ld,size=%d}</query></api><user><company></company><customeruser>%@</customeruser><phoneno>%@</phoneno></user></root>";
    NSString *string = [NSString stringWithFormat:str,page,SIZE,[userDefault valueForKey:@"name"],UUID];
    
    [NetRequest sendRequest:BaseURL parameters:string success:^(id responseObject) {
        NSData *data = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
        NSLog(@"doc:%@",doc);
        NSArray *msgArr = [doc nodesForXPath:@"//msg" error:nil];
        for (DDXMLElement *element in msgArr) {
            if (![element.stringValue isEqualToString:@"查询成功！"]) {
                //[self.view makeToast:element.stringValue duration:1 position:[NSValue valueWithCGSize:CGSizeMake(ViewWidth*0.5, ViewHeight*0.85)]];
                //无数据时显示
                self.isShowEmptyData = YES;
                self.noDataImgName = @"cb";
                
                [self.view addSubview:self.xlTableView];
                
                self.xlTableView.emptyDataSetSource = self;
                self.xlTableView.emptyDataSetDelegate = self;
            }else{
                NSArray *rowArr = [doc nodesForXPath:@"//row" error:nil];
                for (DDXMLElement *item in rowArr) {
                    WorkplaceModel *model = [[WorkplaceModel alloc]init];
                    if ([item elementsForName:@"tp"].count>0) {
                        DDXMLElement *tp = [item elementsForName:@"tp"][0];
                        if (![tp.stringValue isEqualToString:@"0"]) {
                            model.tp = tp.stringValue;
                            DDXMLElement *c_id = [item elementsForName:@"c_id"][0];
                            model.c_id = c_id.stringValue;
                            DDXMLElement *c_no = [item elementsForName:@"c_no"][0];
                            model.c_no = c_no.stringValue;
                            DDXMLElement *name = [item elementsForName:@"name"][0];
                            model.name = name.stringValue;
                            DDXMLElement *nr = [item elementsForName:@"nr"][0];
                            model.nr = nr.stringValue;
                            DDXMLElement *sj = [item elementsForName:@"sj"][0];
                            model.sj = sj.stringValue;
                            DDXMLElement *tx = [item elementsForName:@"tx"][0];
                            model.tx = tx.stringValue;
                            DDXMLElement *zw = [item elementsForName:@"zw"][0];
                            model.zw = zw.stringValue;
                            
                            [self.dataArr addObject:model];
                        }
                    }
                    [_collectionView reloadData];
                }
                NSArray *allpageArr = [doc nodesForXPath:@"//allpage" error:nil];
                for (DDXMLElement *item in allpageArr) {
                    self.allPage = [item.stringValue integerValue];
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        //[self endRefresh];
        //无网络加载失败时显示
        self.isShowEmptyData = YES;
        self.noDataImgName = @"cb";
        self.noDataTitle = @"网络加载失败！";
        [self.view addSubview:self.xlTableView];
        
        self.xlTableView.emptyDataSetSource = self;
        self.xlTableView.emptyDataSetDelegate = self;
        
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
