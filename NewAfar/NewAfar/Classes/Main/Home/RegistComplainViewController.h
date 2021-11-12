//
//  RegistComplainViewController.h
//  NewAfar
//
//  Created by cw on 17/1/3.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RefreshBlock)(BOOL isPop);

@interface RegistComplainViewController : BaseViewController

@property (nonatomic, copy) RefreshBlock refreshBlock;

- (void)refresh:(RefreshBlock)block;

@end
