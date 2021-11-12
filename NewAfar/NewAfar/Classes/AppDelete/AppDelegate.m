//
//  AppDelegate.m
//  NewAfar
//
//  Created by huanghuixiang on 16/9/2.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "StartAPPViewController.h"
#import "AFNetworking.h"
//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//3D Touch
#import "MyCodeViewController.h"
#import "BaseNavigationController.h"
#import "SGGenerateQRCodeVC.h"
#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
//shareSDK
#define SDKey @"1796effc43a20"
#define SDSecret @"626d6acdc49114aec3a324debfcd2598"
//微信
#define WXAppID @"wxcdf48bdbdd0c4c6f"
#define WXAppSecret @"299ca35405233f0775c58c0634faec16"
//新浪
#define SinaAppKey @"1720522258"
#define SinaAppSecret @"8d4f2f58891bbf8f5c142c86a25914eb"
//QQ
#define QQAppID @"1104744025"
#define QQAppKey @"GdiLLicEWLWQWEaI"
// 引入JPush功能所需头文件
#define JpushKey @"8af07bf3869c67b3dcdfdfdf"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate
//退出收到：如果点击推送横幅/通知中心而启动 App，系统将通知传到 didFinishLaunchingWithOptions。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /**
     第一次安装启动
     */
    NSLog(@"%@",UUID);
    if (![userDefault boolForKey:@"everLaunched"]) {
        [userDefault setBool:YES forKey:@"everLaunched"];
        [userDefault setBool:YES forKey:@"firstLaunch"];
    }else{
        [userDefault setBool:NO forKey:@"firstLaunch"];
    }
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[StartAPPViewController alloc]init];
    [self.window makeKeyAndVisible];
    //配置域名
    if (![userDefault boolForKey:@"isChange"]) {
        [userDefault setValue:Domain forKey:@"domain"];
    }
    [userDefault synchronize];
    //网络监测
    [self networkReachability];
    //键盘处理
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    /**
     *  ShareSDK
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShareSDK registerApp:SDKey

              activePlatforms:@[
                                @(SSDKPlatformTypeSinaWeibo),
                                @(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeWechat),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatSession)]
                     onImport:^(SSDKPlatformType platformType)
         {
             switch (platformType)
             {
                     //微信
                 case SSDKPlatformTypeWechat:
                     [ShareSDKConnector connectWeChat:[WXApi class]];
                     break;
                     //QQ
                 case SSDKPlatformTypeQQ:
                     [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                     break;
                     //新浪
                 case SSDKPlatformTypeSinaWeibo:
                     [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                     break;
                 default:
                     break;
             }
         }
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
         {

             switch (platformType)
             {
                 case SSDKPlatformTypeSinaWeibo:
                     //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                     [appInfo SSDKSetupSinaWeiboByAppKey:SinaAppKey
                                               appSecret:SinaAppSecret
                                             redirectUri:@"http://www.sharesdk.cn"
                                                authType:SSDKAuthTypeBoth];
                     break;
                 case SSDKPlatformTypeWechat:
                     [appInfo SSDKSetupWeChatByAppId:WXAppID
                                           appSecret:WXAppSecret];
                     break;
                 case SSDKPlatformTypeQQ:
                     [appInfo SSDKSetupQQByAppId:QQAppID
                                          appKey:QQAppKey
                                        authType:SSDKAuthTypeBoth];
                     break;
                 default:
                     break;
             }
         }];
    });
//    /**
//     *  极光推送
//     */
//    //可以添加自定义categories
//    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
//    //JAppKey : 是你在极光推送申请下来的appKey Jchannel : 可以直接设置默认值即可 Publish channel
//    application.applicationIconBadgeNumber = 0;
//    [JPUSHService setBadge:0];
//    [JPUSHService setupWithOption:launchOptions appKey:JpushKey channel:@"AppStore" apsForProduction:YES]; //如果是生产环境应该设置为YES
    //3D touch
    if ([self support3DTouchFounction]) {
        [self touch3DFounction];
    }
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"注册推送");
}
//前台收到,系统会将通知内容传到 didReceiveRemoteNotification
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"%@",userInfo);
    NSString *alertString = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    if (application.applicationState == UIApplicationStateActive) {
        [ShowAlter showAlertToController:self.window.rootViewController title:@"提示" message:alertString buttonAction:@"确定" buttonBlock:^{
            
        }];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    //[application setApplicationIconBadgeNumber:0];
     NSLog(@"对推送消息的处理");
}
//后台收到,如果开启了 Remote Notification ，系统将推送传到 didReceiveRemoteNotification:fetchCompletionHandler:，否则此时代码中收不到推送。
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
     NSString *alertString = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
                [ShowAlter showAlertToController:self.window.rootViewController title:@"提示" message:alertString buttonAction:@"确定" buttonBlock:^{
        
                }];
    }
    [JPUSHService resetBadge];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
    NSLog(@"后台的远程消息推送:%@---%@",userInfo,[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}
#pragma mark - iOS10
/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
     NSLog(@"推送代理----1");
}
/*
 * @brief handle UserNotifications.framework [didReceiveNotificationResponse:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param response 通知响应对象
 * @param completionHandler
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"推送代理----2");
}
#pragma mark - 网络监测
- (void)networkReachability
{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
     AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
     AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
     AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
     };
     */
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未识别的网络");
                [MBProgressHUD showMessag:@"请检查网络连接" toView:self.window afterDelay:0];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"不可到达的网络");
               [MBProgressHUD showMessag:@"请检查网络连接" toView:self.window afterDelay:0];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"2G,3G,4G...的网络");
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"wifi的网络");
            }
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];
}
- (BOOL)support3DTouchFounction{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 &&self.window.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        NSLog(@"你的手机支持3D Touch!");
        return YES;
    }else {
        NSLog(@"你的手机暂不支持3D Touch!");
        return NO;
    }
}
#pragma mark - 3D Touch
- (void)touch3DFounction{
    UIApplicationShortcutItem * itemOne = [[UIApplicationShortcutItem alloc]initWithType:@"one" localizedTitle:@"分享“管翼通”" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare] userInfo:nil];
    // 设置自定义标签图片
    
    UIApplicationShortcutItem * itemTwo = [[UIApplicationShortcutItem alloc]initWithType:@"two" localizedTitle:@"我的二维码" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"barcode"] userInfo:nil];
    
    UIApplicationShortcutItem * itemThird = [[UIApplicationShortcutItem alloc]initWithType:@"three" localizedTitle:@"扫一扫" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"scan_3D"] userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[itemOne,itemTwo, itemThird];
}
//#pragma mark - 3DTouch回调
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    
    if([shortcutItem.localizedTitle isEqualToString:@"分享“管翼通”"]){
        
        NSArray *arr = @[@"管翼通:https://itunes.apple.com/cn/app/%E7%AE%A1%E7%BF%BC%E9%80%9A/id1144062674?mt=8"];
        
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        
        //设置当前的VC 为rootVC
        
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
            
        }];
        
    }
    if([shortcutItem.localizedTitle isEqualToString:@"我的二维码"]){
        MyCodeViewController *code = [[MyCodeViewController alloc]init];
        BaseNavigationController *navc = [[BaseNavigationController alloc]initWithRootViewController:code];
        navc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.window.rootViewController presentViewController:navc animated:YES completion:^{
            
        }];
    }
    if([shortcutItem.localizedTitle isEqualToString:@"扫一扫"]){
        [self scanFriendCode];
    }
    
}
- (void)scanFriendCode{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
                        BaseNavigationController *navc = [[BaseNavigationController alloc]initWithRootViewController:scanningQRCodeVC];
                        navc.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self.window.rootViewController presentViewController:navc animated:YES completion:^{
                            
                        }];
                        NSLog(@"主线程 - - %@", [NSThread currentThread]);
                    });
                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
            BaseNavigationController *navc = [[BaseNavigationController alloc]initWithRootViewController:scanningQRCodeVC];
            navc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.window.rootViewController presentViewController:navc animated:YES completion:^{
                
            }];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            [ShowAlter showAlertToController:self.window.rootViewController title:@"提示" message:@"请去-> [设置 - 隐私 - 相机 - 管翼通] 打开访问开关" buttonAction:@"取消" buttonBlock:^{
                
            }];
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        [ShowAlter showAlertToController:self.window.rootViewController title:@"提示" message:@"未检测到您的摄像头, 请在真机上测试" buttonAction:@"取消" buttonBlock:^{
            
        }];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
