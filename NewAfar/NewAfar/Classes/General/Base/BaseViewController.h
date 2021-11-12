//
//  BaseViewController.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/19.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//不带下拉菜单的导航条
- (void)customNavigationBar:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight withRightBarButtonItemImage:(NSString *)image;
//带下拉菜单的导航条
- (void)customBarWithDropDown:(NSString *)title hasLeft:(BOOL)isLeft hasRight:(BOOL)isRight;
//右侧按钮
- (void)rightBarClick;
//中间按钮
- (void)titleClick:(UIButton *)sender;
//返回按钮
- (void)backPage;
#pragma mark - 无数据显示页
@property(nonatomic,retain) UITableView *xlTableView;

//是否显示空数据页面  默认为显示
@property(nonatomic,assign) BOOL isShowEmptyData;

//空数据页面的title -- 可不传，默认为：暂无任何数据
@property(nonatomic,strong) NSString *noDataTitle;
//空数据页面的图片 -- 可不传，默认图片为：NoData
@property(nonatomic,strong) NSString *noDataImgName;

//显示副标题的时候，需要赋值副标题，否则不显示
@property(nonatomic,strong) NSString *noDataDetailTitle;

//按钮标题、图片 --不常用
@property(nonatomic,strong) NSString *btnTitle;
@property(nonatomic,strong) NSString *btnImgName;

@end
