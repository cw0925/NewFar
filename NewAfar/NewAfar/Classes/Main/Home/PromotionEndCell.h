//
//  PromotionEndCell.h
//  AfarSoftManager
//
//  Created by 陈伟 on 16/6/30.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionModel.h"
@interface PromotionEndCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *provider;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *saleprice;
@property (weak, nonatomic) IBOutlet UILabel *buyprice;
@property (weak, nonatomic) IBOutlet UILabel *plansum;
@property (weak, nonatomic) IBOutlet UILabel *actualsum;
@property (weak, nonatomic) IBOutlet UILabel *orderdate;
@property (weak, nonatomic) IBOutlet UILabel *promotiondate;
- (void)configCell:(PromotionModel *)model;
@end
