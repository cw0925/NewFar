//
//  GenerateUUID.m
//  AfarSoftManager
//
//  Created by 陈伟 on 16/6/24.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "GenerateUUID.h"
#import "KeychainItemWrapper.h"

@implementation GenerateUUID
//生成设备唯一标识(UUID,keychain保存)
+ (NSString *)generateDeviceUniqueIdentifier
{
    //1.创建一个钥匙串对象
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"MyitemWrapper" accessGroup:nil];
    id kPassWord = (__bridge id)kSecValueData;
    //获取钥匙串的数据
    NSString *uuid = [wrapper objectForKey:kPassWord];
    // 钥匙串是类似于字典存储的,在存储的时候,必须使用系统提供的两个key值,其他的存不进去
    //id kUserName = (__bridge id)kSecAttrAccount;
    //    id kPassWord = (__bridge id)kSecValueData;
    if ([uuid isEqualToString:@""]||!uuid) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [wrapper setObject:uuid forKey:kPassWord];
    }
    //NSLog(@"UUID:%@",[wrapper objectForKey:kPassWord]);
    return [wrapper objectForKey:kPassWord];
}
@end
