//
//  RealControlCell.m
//  AfarSoftManager
//
//  Created by 陈伟 on 16/6/2.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "RealControlCell.h"

@implementation RealControlCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configCell:(MonitorModel *)model
{
    _depart.textColor = [UIColor blackColor];
    _sum.textColor = [UIColor blackColor];
    _cost.textColor = [UIColor blackColor];
    _sale.textColor = [UIColor blackColor];
    
    if ([model.bm isEqualToString:@"999999"]) {
        model.bm = @"";
    }
    _depart.text = [NSString stringWithFormat:@"%@ %@",model.bm,model.name];
    _sum.text = [NSString stringWithFormat:@"%.02f",[model.sjsale doubleValue]/10000.0];
    _cost.text = [NSString stringWithFormat:@"%.02f",[model.cb doubleValue]/10000.0];
    _sale.text = [NSString stringWithFormat:@"%.02f",[model.mll doubleValue]*100];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
