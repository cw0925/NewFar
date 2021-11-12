//
//  ManageLeftCell.h
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageHisModel.h"

@interface ManageLeftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *deadline;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *rpeople;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *mpeople;
@property (weak, nonatomic) IBOutlet UILabel *state;
- (void)configCell:(ManageHisModel *)model;
@end
