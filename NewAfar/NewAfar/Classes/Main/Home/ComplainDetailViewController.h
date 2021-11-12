//
//  ComplainDetailViewController.h
//  NewAfar
//
//  Created by cw on 16/12/22.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"
#import "ComplainModel.h"

typedef void (^UpdateBlock)(NSInteger commentCount);

@interface ComplainDetailViewController : BaseViewController

@property(nonatomic,strong)ComplainModel *model;

@property (nonatomic, copy) UpdateBlock updateBlock;
- (void)update:(UpdateBlock)block;

@end
