//
//  CycleScrollView.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CycleScrollView.h"
#import "ScrollModel.h"

@implementation CycleScrollView


//轮播图
- (void)createScrollView:(UIView *)view
{
    // 网络加载 --- 创建带标题的图片轮播器
   SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,ScreenWidth, CGRectGetHeight(view.frame)) delegate:self placeholderImage:[UIImage imageNamed:@"place.jpg"]];
    cycleScrollView.autoScrollTimeInterval = 4;
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *pathArr = [NSMutableArray array];
    for (NSInteger i = 0 ; i < _iconArr.count; i++) {
        [titleArr addObject:@""];
        ScrollModel *model = _iconArr[i];
        [pathArr addObject:model.path];
    }
    cycleScrollView.imageURLStringsGroup = pathArr;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.titlesGroup = titleArr;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [view addSubview:cycleScrollView];
}
#pragma mark - SDCycleScrollViewDelegate
/**图片点击回调*/
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    ScrollModel *model = _iconArr[index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
}
@end
