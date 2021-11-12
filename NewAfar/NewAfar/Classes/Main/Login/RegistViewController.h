//
//  RegistViewController.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/22.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *showText);

@interface RegistViewController : UIViewController

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
