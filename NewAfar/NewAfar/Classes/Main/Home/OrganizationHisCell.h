//
//  OrganizationHisCell.h
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationHisModel.h"

@interface OrganizationHisCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *organization;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *customs;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *price;

- (void)configCell:(OrganizationHisModel *)model;

@end
