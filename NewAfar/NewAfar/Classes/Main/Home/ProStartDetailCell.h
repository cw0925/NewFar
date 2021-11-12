//
//  ProStartDetailCell.h
//  AfarSoftManager
//
//  Created by 陈伟 on 16/7/12.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionModel.h"

@interface ProStartDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *supplier;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *buy;
@property (weak, nonatomic) IBOutlet UILabel *sale;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *proDate;
- (void)configCell:(PromotionModel *)model;
@end
