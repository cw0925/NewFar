//
//  DatePickView.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/3.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *点击textField弹出日期选择器
 */
//代理实现选择器上面的取消、确定按钮
@protocol ChoseClickDelegate <NSObject>

- (void)choseBtnClick:(UIButton *)sender;

@end

@interface DatePickView : UIPickerView

@property(nonatomic,strong)UILabel *title;

@property(nonatomic,weak)id<ChoseClickDelegate> choseDelegate;

- (instancetype)initDatePickView;
//点击textfield显示选择器
- (void)showPickViewWhenClick:(UITextField *)textfield;

@end
