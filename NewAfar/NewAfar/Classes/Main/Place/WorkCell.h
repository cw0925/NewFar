//
//  WorkCell.h
//  NewAfar
//
//  Created by cw on 16/12/13.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkplaceModel.h"

@interface WorkCell : UITableViewCell

@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIButton *praiseBtn;

@property(nonatomic,strong)WorkplaceModel *workModel;

- (void)configCell:(WorkplaceModel *)model;

@end
