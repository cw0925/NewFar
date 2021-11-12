//
//  RetailDetailViewController.h
//  NewAfar
//
//  Created by cw on 16/12/24.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RefreshBlock)(BOOL isPop);

@interface RetailDetailViewController : BaseViewController

@property(nonatomic,copy)NSString *tip;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *title_ID;


@property (nonatomic, copy) RefreshBlock refreshBlock;

- (void)refresh:(RefreshBlock)block;

@end
