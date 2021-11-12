//
//  HereManager.m
//  Here
//
//  Created by  李冲 on 16/4/26.
//  Copyright © 2016年 DUC-apple3. All rights reserved.
//

#import "HereManager.h"

static HereManager *manager;

@interface HereManager ()
{
    dispatch_source_t _registerTimer;//注册界面计时器
        dispatch_source_t _captchaTimer;//忘记密码界面验证码计时器
}

@end

@implementation HereManager

/**注册界面计时开始*/
-(void)setRegiestVerifCountTime:(NSInteger)regiestVerifCountTime{
    if (_regiestVerifCountTime)return;
    _regiestVerifCountTime = regiestVerifCountTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (!_registerTimer) _registerTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_registerTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self) weakself = self;
    dispatch_source_set_event_handler(_registerTimer, ^{
        if(_regiestVerifCountTime>0){
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新时间
                _regiestVerifCountTime--;
            });
        }else{//倒计时结束，关闭
            [weakself stopRegisterCountTime];
        }
    });
    if (_registerTimer) dispatch_resume(_registerTimer);
}
/**停止注册计时*/
-(void)stopRegisterCountTime{
    if (_registerTimer) dispatch_source_cancel(_registerTimer);
    _registerTimer = nil;
    _regiestVerifCountTime = 0;
}
/**忘记密码界面计时器**/
- (void)setCaptchaCountTime:(NSInteger)captchaCountTime {
    if (_captchaCountTime)return;
    NSLog(@"%ld",captchaCountTime);
    NSLog(@"%@",_captchaTimer);
    
    _captchaCountTime = captchaCountTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (!_captchaTimer) _captchaTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_captchaTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self) weakself = self;
    dispatch_source_set_event_handler(_captchaTimer, ^{
        if(_captchaCountTime>0){
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新时间
                _captchaCountTime--;
            });
        }else{//倒计时结束，关闭
            [weakself stopCaptchaCountTime];
        }
    });
    
    if (_captchaTimer) dispatch_resume(_captchaTimer);

}

/**停止验证计时*/
-(void)stopCaptchaCountTime{
    NSLog(@"剩余时间：%ld",_captchaCountTime);
    if (_captchaTimer) dispatch_source_cancel(_captchaTimer);
    
    _captchaTimer = nil;
    NSLog(@"清空了：%@",_captchaTimer);
    
    _captchaCountTime = 0;
}

/**以下是创建单例的方法*/
+(instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}
- (id)copyWithZone:(NSZone *)zone{

    return manager;
}

@end
