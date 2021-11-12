//
//  ShowActionSheet.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

// 第一个void 返回值
// 第二个void  参数
typedef void (^buttonBlock)(void);

@interface ShowActionSheet : UIAlertController

+ (void)showActionSheetToController:(UIViewController *)targetController takeBlock:(void (^)(void))takeB phoneBlock:(void(^)(void))pictureB;

@end
