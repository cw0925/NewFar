//
//  ReportCell.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/1.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportModel.h"

@interface ReportCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *isRead;

- (void)configCell:(ReportModel *)model;

@end
