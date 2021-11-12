//
//  MBProgressHUD+AddHud.h
//  Here
//
//  Created by DUC-apple3 on 16/4/26.
//  Copyright © 2016年 DUC-apple3. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>


typedef void(^callBackBlock)(void);

@interface MBProgressHUD (AddHud)

/**添加自定义View不带block*/
+ (MBProgressHUD *)addCustomHUDWithImage:(NSString *)imageName messageTitle:(NSString *)title toView:(UIView *)view afterDelay:(NSTimeInterval)timeInterval;

/**添加自定义View带block*/
+ (MBProgressHUD *)addCustomHUDWithImage:(NSString *)imageName messageTitle:(NSString *)title toView:(UIView *)view afterDelay:(NSTimeInterval)timeInterval complite:(callBackBlock)complite;

/**只有文字不带小菊花*/
+ (instancetype)showText:(NSString *)text toView:(UIView *)view;

/**只有文字不带小菊花有回调block*/
+ (instancetype)showText:(NSString *)text toView:(UIView *)view complite:(void(^)(void))complite;

/**有文字带小菊花,NSTimeInterval传0默认是2秒*/
+ (void)showMessag:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)timeInterval;

/**有文字带小菊花有block,NSTimeInterval传0默认是2秒*/
+ (void)showMessag:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)timeInterval complite:(void(^)(void))complite;

/**有文字带小菊花不会自动消失*/
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

/**网络出错显示信息,默认显示2秒*/
+ (void)showAFNErrorWithStatus:(NSInteger)status;
@end
