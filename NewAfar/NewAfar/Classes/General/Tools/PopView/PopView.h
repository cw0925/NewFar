//
//  PopView.h
//  PopView
//
//  Created by 陈伟 on 16/8/3.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemClickDelegate <NSObject>

//点击事件
- (void)clickCell:(NSInteger)row;

@end

@interface PopView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)id<ItemClickDelegate>itemDelegaate;

- (instancetype)initPopView;
- (void)showPopViewWhenClick:(UIButton *)sender atView:(UIView *)view withArray:(NSArray *)arr;

- (void)remove;

@end
