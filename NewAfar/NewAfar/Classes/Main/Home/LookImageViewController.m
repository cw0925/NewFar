//
//  LookImageViewController.m
//  NewAfar
//
//  Created by cw on 16/12/23.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "LookImageViewController.h"
#import "GetAlbumPhotos.h"

@interface LookImageViewController ()

@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation LookImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"查看大图" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    
    [self initUI];
}
- (void)initUI
{
    NSArray *originalArr = [[GetAlbumPhotos defaultGetAlbumPhotos] getThumbnailImages];
    
    for (NSInteger i = 0; i<_imageArr.count; i++) {
        if ([_imageArr[i] boolValue]) {
            [self.dataArr addObject:originalArr[i]];
        }
    }
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, ViewWidth, ViewHeight)];
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(ViewWidth*(_dataArr.count-1), 0);
    [self.view addSubview:scroll];
    
    for (NSInteger i = 0; i<_dataArr.count-1; i++) {
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth*i, 0, ViewWidth, ViewHeight)];
        imv.image = _dataArr[i];
        [scroll addSubview:imv];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
