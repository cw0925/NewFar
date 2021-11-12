//
//  GoodRealTimeCell.h
//  AfarSoftManager
//
//  Created by 陈伟 on 16/5/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface GoodRealTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gcode;
@property (weak, nonatomic) IBOutlet UILabel *barcode;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *sale;
@property (weak, nonatomic) IBOutlet UILabel *ratio;
@property (weak, nonatomic) IBOutlet UILabel *sum;
- (void)configCell:(GoodModel *)model;
@end
