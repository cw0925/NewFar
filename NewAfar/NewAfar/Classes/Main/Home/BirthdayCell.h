//
//  BirthdayCell.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/2.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BirthModel.h"

@interface BirthdayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *blessBtn;
- (void)configCell:(BirthModel *)model;
@end
