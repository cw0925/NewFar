//
//  CurrentDate.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/3.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CurrentDate.h"

@implementation CurrentDate

+ (NSString *)getCurrentDate
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];//获取当前日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
@end
