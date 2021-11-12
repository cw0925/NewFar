//
//  SysConfig.h
//  NewAfar
//
//  Created by afarsoft on 2018/1/25.
//  Copyright © 2018年 afarsoft. All rights reserved.
//

#ifndef SysConfig_h
#define SysConfig_h
/**NSLOG*/
#if DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil

#endif
/**UUID*/
//设备的UUID（app卸载重装也不会改变,通用-还原-抹掉所有内容和设置会改变）
//2.Target-Capabilities-Keychain Sharing-ON  未设置
#define UUID [GenerateUUID generateDeviceUniqueIdentifier]
//#define UUID @"lblblblblblbtt"
//当前日期
#define Date [CurrentDate getCurrentDate]
/**domain*/
#define Domain @"king.afarsoft.com"
/**屏幕参数*/
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define ViewWidth  self.view.frame.size.width
#define ViewHeight self.view.frame.size.height
//
#define WidthIphone6 [UIScreen mainScreen].bounds.size.width/375
#define BaseFont(fontSize) [UIFont fontWithName:@"PingFang SC" size:fontSize]
//
//#define BarHeight ([UIScreen mainScreen].bounds.size.width > 667.0)?44:32
//#define BarHeight (IS_PhoneXAll ? 44.f : 32.f)
//横屏下导航栏、状态栏高度
/**状态栏:全面屏iPhone竖屏44，全面屏iPhone横屏0，普通iPhone为20/导航栏:屏幕宽度小于400的设备横屏时为32，其余情况为44*/

#define NavigationBarHeight (([UIScreen mainScreen].bounds.size.height > 400.0)?44.0:32.0)

/**Color(有参数)*/
#define RGBColor(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#define BaseColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:252/255.0 alpha:1]

#define CellColor [UIColor colorWithRed:53/255.0 green:153/255.0 blue:243/255.0 alpha:1]

/**拿到StoryBoard里的Controller*/
#define StoryBoard(name,identifier) [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:identifier];

/**PushController*/
#define PushController(controller) [self.navigationController pushViewController:controller animated:YES];
/**NSUserDefaults*/
#define userDefault [NSUserDefaults standardUserDefaults]
/**
 *  登录用户手机号
 */
#define USER [userDefault valueForKey:@"name"]
/**
 更新后机型判断（iPhone4-iPhoneXSMax）
 */
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6 6s 7系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6p 6sp 7p系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)

//判断iPhoneX所有系列
#define IS_PhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define k_Height_NavContentBar 44.0f
#define k_Height_StatusBar (IS_PhoneXAll? 44.0 : 20.0)
#define k_Height_NavBar (IS_PhoneXAll ? 88.0 : 64.0)
#define k_Height_TabBar (IS_PhoneXAll ? 83.0 : 49.0)

// 判断是否是iPhone X
//#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (IS_PhoneXAll ? 44.f : 20.f)
// 导航栏高度
#define NVHeight (IS_PhoneXAll ? 88.f : 64.f)
// tabBar高度
#define TBHeight (IS_PhoneXAll ? (49.f+34.f) : 49.f)
//底部高度（非安全区）
#define BottomHeight (IS_PhoneXAll ? 34.f : 0)
//iPhone X竖屏时占满整个屏幕的控制器的view的safeAreaInsets是（44，0，34，0），横屏是（0，44，21，44），inset后的区域正好是safeAreaLayoutGuide区域
#endif /* SysConfig_h */
