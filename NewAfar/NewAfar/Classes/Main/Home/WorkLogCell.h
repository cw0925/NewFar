//
//  WorkLogCell.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogModel.h"

@interface WorkLogCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *postion;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (nonatomic, strong) LogModel *model;

@end
