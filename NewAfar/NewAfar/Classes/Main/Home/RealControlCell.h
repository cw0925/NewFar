//
//  RealControlCell.h
//  AfarSoftManager
//
//  Created by 陈伟 on 16/6/2.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorModel.h"

@interface RealControlCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *sale;
- (void)configCell:(MonitorModel *)model;

@end
