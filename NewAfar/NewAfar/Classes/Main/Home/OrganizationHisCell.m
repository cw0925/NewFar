//
//  OrganizationHisCell.m
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "OrganizationHisCell.h"

@implementation OrganizationHisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(OrganizationHisModel *)model
{
    _organization.textColor = [UIColor blackColor];
    _sum.textColor = [UIColor blackColor];
    _customs.textColor = [UIColor blackColor];
    _profit.textColor = [UIColor blackColor];
    _rate.textColor = [UIColor blackColor];
    _price.textColor = [UIColor blackColor];
    
    if ([model.name isEqualToString:@"合计"]) {
        _organization.text = model.name;
    }else{
        _organization.text = [NSString stringWithFormat:@"%@ %@",model.C_adno,model.name];
    }
    if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
        _sum.text = [NSString stringWithFormat:@"%.02f",[model.amt doubleValue]/10000.0];
        _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]/10000.0];
    }else{
        _sum.text = [NSString stringWithFormat:@"%.02f",[model.amt doubleValue]];
        _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]];
    }
    _customs.text = model.customers;
    _rate.text = [NSString stringWithFormat:@"%.02f",[model.mll doubleValue]*100];
    _price.text = [NSString stringWithFormat:@"%.02f",[model.kdj doubleValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
