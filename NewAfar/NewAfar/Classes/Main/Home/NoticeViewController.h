//
//  NoticeViewController.h
//  NewAfar
//
//  Created by cw on 17/1/11.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^RefreshBlock)(BOOL isPop);

@interface NoticeViewController : BaseViewController

@property(nonatomic,copy)NSString *heading;
@property(nonatomic,copy)NSString *date;

@property(nonatomic,copy)NSString *ggID;

@property (nonatomic, copy) RefreshBlock refreshBlock;

- (void)refresh:(RefreshBlock)block;
@end
