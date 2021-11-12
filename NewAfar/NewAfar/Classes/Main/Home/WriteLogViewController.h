//
//  WriteLogViewController.h
//  NewAfar
//
//  Created by cw on 17/2/7.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RefreshBlock)(BOOL isPop);

@interface WriteLogViewController : BaseViewController

@property(nonatomic,copy)NSString *c_newid;

@property(nonatomic,copy)NSString *date;

@property(nonatomic,copy)NSString *reader;
@property(nonatomic,copy)NSString *phone;

@property(nonatomic,assign)BOOL isMiss;

@property (nonatomic, copy) RefreshBlock refreshBlock;

- (void)refresh:(RefreshBlock)block;

@end
