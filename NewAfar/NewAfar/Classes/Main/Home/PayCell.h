//
//  PayCell.h
//  NewAfar
//
//  Created by cw on 16/12/17.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModel.h"

@interface PayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *payID;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *cashier;
@property (weak, nonatomic) IBOutlet UILabel *date;
- (void)configCell:(PayModel *)model;
@end
