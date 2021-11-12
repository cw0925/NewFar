//
//  AlbumViewController.m
//  NewAfar
//
//  Created by cw on 16/11/24.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "AlbumViewController.h"
#import "GetAlbumPhotos.h"
#import "ImgCell.h"

@interface AlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,copy)NSMutableArray *stateArr;
@property(nonatomic,copy)NSMutableArray *selImgArr;
@property(nonatomic,copy)NSMutableArray *indexPathArr;

@end

@implementation AlbumViewController
{
    NSArray *_dataArr;
    NSArray *_originalDataArr;
    UICollectionView *homeCollection;
    GetAlbumPhotos *album;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"所有照片" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
    [self initData];
    
    [self initFootView];
}
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;//最小行间距(当垂直布局时是行间距，当水平布局时可以理解为列间距)
    layout.minimumInteritemSpacing = 10;//两个单元格之间的最小间距
    layout.itemSize = CGSizeMake((ViewWidth-50)/4, (ViewWidth-50)/4);
    homeCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NVHeight+10,ViewWidth,ViewHeight-NVHeight-10-45-10) collectionViewLayout:layout];
    homeCollection.delegate = self;
    homeCollection.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    homeCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:homeCollection];
    [homeCollection registerNib:[UINib nibWithNibName:@"ImgCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.img.image = _dataArr[indexPath.item];
    [cell.flag addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.flag.selected = [_stateArr[indexPath.item] boolValue];
    return cell;
}
//选择图片
- (void)itemClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    ImgCell *cell = (ImgCell *)sender.superview.superview;
    NSIndexPath *index = [homeCollection indexPathForCell:cell];
    
    if (sender.selected) {
        NSLog(@"选中");
        if (_selImgArr.count+_sum<6) {
            [self.selImgArr addObject:_dataArr[index.item]];
            [self.indexPathArr addObject:[NSString stringWithFormat:@"%ld",(long)index.item]];
        }else{
            sender.selected = NO;
            [ShowAlter showAlertToController:self title:@"提示" message:@"最多只能选择6张图片！" buttonAction:@"取消" buttonBlock:^{
                
            }];
        }
        NSLog(@"选中-:%lu",(unsigned long)_selImgArr.count);
    }else if(!sender.selected){
        NSLog(@"未选中");
        if (_selImgArr.count+_sum <7) {
            [self.selImgArr removeObject:_dataArr[index.item]];
            [self.indexPathArr removeObject:[NSString stringWithFormat:@"%ld",(long)index.item]];
        }else{
            sender.selected = NO;
            [ShowAlter showAlertToController:self title:@"提示" message:@"最多只能选择6张图片！" buttonAction:@"取消" buttonBlock:^{
                
            }];
        }
        NSLog(@"未选中-:%lu",(unsigned long)_selImgArr.count);
    }
    [_stateArr replaceObjectAtIndex:index.item withObject:[NSNumber numberWithBool:sender.selected]];
    NSLog(@"%@",_stateArr);
}

- (void)initFootView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,ViewHeight-45-BottomHeight,ViewWidth, 45)];
    view.backgroundColor = RGBColor(211, 212, 213);
    [self.view addSubview:view];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(0, 157, 37) forState:UIControlStateNormal];
    btn.frame = CGRectMake(ViewWidth-100, 5, 100, 35);
    [view addSubview:btn];
    [btn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)returnSelImg:(ReturnImgBlock)block
{
    self.selBlock = block;
}
//点击完成
- (void)finishClick:(UIButton *)sender
{
    
    if (self.selBlock ) {
        self.selBlock(_selImgArr,_indexPathArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initData
{
    _dataArr = [[GetAlbumPhotos defaultGetAlbumPhotos]getThumbnailImages];
    NSLog(@"%lu",(unsigned long)_dataArr.count);

    for (NSInteger i = 0; i<_dataArr.count; i++) {
        [self.stateArr addObject:[NSNumber numberWithBool:NO]];
    }
    //[homeCollection reloadData];
}

- (NSMutableArray *)selImgArr
{
    if (!_selImgArr) {
        _selImgArr = [NSMutableArray array];
    }
    return _selImgArr;
}
- (NSMutableArray *)stateArr
{
    if (!_stateArr) {
        _stateArr = [NSMutableArray array];
    }
    return _stateArr;
}
- (NSMutableArray *)indexPathArr
{
    if (!_indexPathArr) {
        _indexPathArr = [NSMutableArray array];
    }
    return _indexPathArr;
}
@end
