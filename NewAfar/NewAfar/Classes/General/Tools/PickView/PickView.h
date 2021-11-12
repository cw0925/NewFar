//
//  PickView.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/2.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *点击textField弹出选择器
 */
//代理实现选择器上面的取消、确定按钮
@protocol BtnClickDelegate <NSObject>

- (void)btnClick:(UIButton *)sender;

@end

@interface PickView : UIPickerView

@property(nonatomic,strong)UILabel *title;

@property(nonatomic,weak)id<BtnClickDelegate> clickDelegate;

- (instancetype)initPickViewWithArray:(NSArray *)array;
//点击textfield显示选择器
- (void)showPickViewWhenClick:(UITextField *)textfield;
//刷新数据
- (void)reloadData;
@end
