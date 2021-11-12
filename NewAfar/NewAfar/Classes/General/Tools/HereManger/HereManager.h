//
//  HereManager.h
//  Here
//
//  Created by  李冲 on 16/4/26.
//  Copyright © 2016年 DUC-apple3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HereManager : NSObject

@property (nonatomic,assign) __block NSInteger regiestVerifCountTime; //注册验证码倒计时时间
@property (nonatomic, assign)  __block NSInteger captchaCountTime;    //验证码倒计时

+(instancetype)sharedManager;


-(void)stopRegisterCountTime;
-(void)stopCaptchaCountTime;
@end
