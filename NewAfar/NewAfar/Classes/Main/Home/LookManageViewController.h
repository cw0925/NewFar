//
//  LookManageViewController.h
//  NewAfar
//
//  Created by cw on 16/11/28.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RefreshBlock)(BOOL isPop);

@interface LookManageViewController : BaseViewController

@property (nonatomic, copy) RefreshBlock refreshBlock;

- (void)refresh:(RefreshBlock)block;

@property(nonatomic,copy)NSString *c_id;

@end
