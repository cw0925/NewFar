//
//  DepartHisCell.m
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "DepartHisCell.h"

@implementation DepartHisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(DepartHisModel *)model
{
    _department.textColor = [UIColor blackColor];
    _sum.textColor = [UIColor blackColor];
    _customs.textColor = [UIColor blackColor];
    _profit.textColor = [UIColor blackColor];
    _price.textColor = [UIColor blackColor];
    _sale.textColor = [UIColor blackColor];
    
    if ([model.adno isEqualToString:@"999999"]) {
        model.adno = @"";
    }
    if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
        _sum.text = [NSString stringWithFormat:@"%.02f",[model.amt doubleValue]/10000.0];
        _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]/10000.0];
    }else{
        _sum.text = [NSString stringWithFormat:@"%.02f",[model.amt doubleValue]];
        _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]];
    }
    
    _department.text = [NSString stringWithFormat:@"%@ %@",model.adno,model.name];
//    _sum.text = [NSString stringWithFormat:@"%.02f",[model.amt doubleValue]/10000.0];
    _customs.text = model.customers;
//    _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]/10000.0];
    _price.text = [NSString stringWithFormat:@"%.02f",[model.mll doubleValue]*100];
    _sale.text = [NSString stringWithFormat:@"%.02f",[model.kdj doubleValue]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
