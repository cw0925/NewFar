//
//  ManageHisCell.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageHisModel.h"

@interface ManageHisCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *rpeople;
@property (weak, nonatomic) IBOutlet UILabel *punish;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *mpeople;
@property (weak, nonatomic) IBOutlet UILabel *state;

- (void)configCell:(ManageHisModel *)model;

@end
