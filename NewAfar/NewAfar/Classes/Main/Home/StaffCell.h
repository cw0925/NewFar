//
//  StaffCell.h
//  NewAfar
//
//  Created by CW on 2017/4/10.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffModel.h"

@interface StaffCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *flag;
- (void)configCell:(StaffModel *)model;

@end
