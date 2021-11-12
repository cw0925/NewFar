//
//  ClassifyHisCell.h
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyHisModel.h"

@interface ClassifyHisCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *classify;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *customs;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *sale;
- (void)configCell:(ClassifyHisModel *)model;
@end
