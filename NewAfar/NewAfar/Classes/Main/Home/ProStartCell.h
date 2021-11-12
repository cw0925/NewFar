//
//  ProStartCell.h
//  AfarSoftManager
//
//  Created by 陈伟 on 16/7/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionModel.h"

@interface ProStartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
- (void)configCell:(PromotionModel *)model;
@end
