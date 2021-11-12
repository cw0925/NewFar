//
//  MBProgressHUD+AddHud.m
//  Here
//
//  Created by DUC-apple3 on 16/4/26.
//  Copyright © 2016年 DUC-apple3. All rights reserved.
//

#import "MBProgressHUD+AddHud.h"
@implementation MBProgressHUD (AddHud)

#pragma mark /**添加自定义View不带block*/
+ (MBProgressHUD *)addCustomHUDWithImage:(NSString *)imageName messageTitle:(NSString *)title toView:(UIView *)view afterDelay:(NSTimeInterval)timeInterval{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD  *HUD = [self addCustomHUDWithImage:imageName messageTitle:title toView:view];
    // YES代表需要蒙版效果
    HUD.dimBackground = YES;
    // 隐藏时候从父控件中移除
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:timeInterval?timeInterval:2];
    [view addSubview:HUD];
    return HUD;
}
#pragma mark //添加自定义提示窗带block
+ (MBProgressHUD *)addCustomHUDWithImage:(NSString *)imageName messageTitle:(NSString *)title toView:(UIView *)view afterDelay:(NSTimeInterval)timeInterval complite:(callBackBlock)complite{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;

    __weak MBProgressHUD  *HUD = [self addCustomHUDWithImage:imageName messageTitle:title toView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hide:YES];
        if (complite)complite();
    });
    return HUD;
}
#pragma mark --私有方法
+ (MBProgressHUD *)addCustomHUDWithImage:(NSString *)imageName messageTitle:(NSString *)title toView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD  *HUD = [[MBProgressHUD alloc] initWithView:view];
    UIView *showview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,200*WidthIphone6, 60*WidthIphone6)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.center = showview.center;
    [showview addSubview:imageView];
    HUD.customView = showview;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = title;
    // YES代表需要蒙版效果
    HUD.dimBackground = YES;
    // 隐藏时候从父控件中移除
    HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
    [view addSubview:HUD];
    
    return HUD;
}
#pragma mark /**只有文字不带小菊花*/
+ (instancetype)showText:(NSString *)text toView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
    return hud;
}
#pragma mark - /**只有文字不带小菊花有回调block*/
+ (instancetype)showText:(NSString *)text toView:(UIView *)view complite:(void(^)(void))complite{
    MBProgressHUD *hud = [self showText:text toView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (complite)complite();
    });
    return hud;
}
#pragma mark -- /**有文字带小菊花不会自动消失*/
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}
#pragma mark -- /**有文字带小菊花,NSTimeInterval传0默认是2秒*/
+(void)showMessag:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)timeInterval{
    MBProgressHUD * hud = [self showMessag:message toView:view];
    [hud hide:YES afterDelay:timeInterval?timeInterval:2];
}
#pragma mark -- /**有文字带小菊花有block,NSTimeInterval传0默认是2秒*/
+(void)showMessag:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)timeInterval complite:(void (^)(void))complite{
    __weak MBProgressHUD * hud = [self showMessag:message toView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval?timeInterval:2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
        if (complite)complite();
    });
}

#pragma mark -- /**网络出错显示信息,默认显示2秒*/
+ (void)showAFNErrorWithStatus:(NSInteger)status{
    NSString *text = [NSString string];
    switch (status) {
        case -1:
            text = @"未知网络";
            break;
        case 0:
            text = @"没有网络";
            break;
        case 1:
            text = @"手机网络";
            break;
        case 2:
            text = @"WIFI 网络";
            break;
        case 3:
            text = @"网络错误";
            break;
        default:
            text = @"错误";
            break;
    }
    [self showMessag:text toView:nil afterDelay:0];
    
}
@end
