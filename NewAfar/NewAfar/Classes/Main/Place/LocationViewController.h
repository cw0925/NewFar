//
//  LocationViewController.h
//  NewAfar
//
//  Created by cw on 16/10/17.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnTextBlock)(NSString *showText);

@interface LocationViewController : BaseViewController

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
