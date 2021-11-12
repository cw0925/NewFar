//
//  BusinessViewController.h
//  NewAfar
//
//  Created by CW on 2017/4/18.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnTextBlock)(NSString *showText);

@interface BusinessViewController : BaseViewController

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
