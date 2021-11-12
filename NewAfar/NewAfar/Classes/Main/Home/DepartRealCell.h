//
//  DepartRealCell.h
//  NewAfar
//
//  Created by cw on 16/12/16.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartRealModel.h"

@interface DepartRealCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *customs;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *sale;
- (void)configCell:(DepartRealModel *)model;

@end
