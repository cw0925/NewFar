//
//  CommentViewController.h
//  NewAfar
//
//  Created by cw on 16/10/12.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"
#import "WorkplaceModel.h"

typedef void (^PassValueBlock)(NSInteger commentNum,NSInteger praiseNum);

@interface CommentViewController : BaseViewController

@property(nonatomic,strong)WorkplaceModel  *dataModel;//内容详情

@property (nonatomic, copy) PassValueBlock passBlock;

- (void)refresh:(PassValueBlock)block;

@end
