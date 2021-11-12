//
//  CarryViewController.h
//  NewAfar
//
//  Created by cw on 16/12/12.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RefreshBlock)(BOOL isPop);

@interface CarryViewController : BaseViewController

@property (nonatomic, copy) RefreshBlock refreshBlock;

- (void)refresh:(RefreshBlock)block;

@end
