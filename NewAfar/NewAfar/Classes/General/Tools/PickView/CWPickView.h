//
//  CWPickView.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/8.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理实现选择器上面的取消、确定按钮
@protocol SenderClickDelegate <NSObject>

- (void)senderClick:(UIButton *)sender;

@end

@interface CWPickView : UIView

@property(nonatomic,weak)id<SenderClickDelegate> senderDelegate;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIPickerView *pickview;
//点击Button弹出选择器
- (instancetype)initPickViewWithArray:(NSArray *)arr;
//显示
- (void)showAt:(UIView *)view;

- (void)showAt:(UIView *)view whenClick:(UIButton *)sender;
//移除
-(void)remove;
@end
