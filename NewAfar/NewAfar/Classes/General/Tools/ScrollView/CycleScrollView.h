//
//  CycleScrollView.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCycleScrollView.h" 

@interface CycleScrollView : NSObject<SDCycleScrollViewDelegate>
@property(nonatomic,copy)NSArray *iconArr;
- (void)createScrollView:(UIView *)view;
@end
