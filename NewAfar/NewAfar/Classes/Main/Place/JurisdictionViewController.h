//
//  JurisdictionViewController.h
//  NewFarSoft
//
//  Created by CW on 16/8/24.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnLimitBlock)(NSString *showLimit);

@interface JurisdictionViewController : BaseViewController

@property (nonatomic, copy) ReturnLimitBlock returnLimitBlock;

- (void)returnLimit:(ReturnLimitBlock)block;

@end
