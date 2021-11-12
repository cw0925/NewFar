//
//  ClassifyHisCell.m
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ClassifyHisCell.h"

@implementation ClassifyHisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(ClassifyHisModel *)model
{
    _classify.textColor = [UIColor blackColor];
    _sum.textColor = [UIColor blackColor];
    _customs.textColor = [UIColor blackColor];
    _profit.textColor = [UIColor blackColor];
    _price.textColor = [UIColor blackColor];
    _sale.textColor = [UIColor blackColor];
    
    if ([model.c_ccode isEqualToString:@"999999"]) {
        model.c_ccode = @"";
    }
    _classify.text = [NSString stringWithFormat:@"%@ %@",model.c_ccode,model.name];
    _sum.text = [NSString stringWithFormat:@"%.02f",[model.amt doubleValue]/10000.0];
    _customs.text = model.customers;
    _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]/10000.0];;
    _price.text = [NSString stringWithFormat:@"%.02f",[model.mll doubleValue]*100];
    _sale.text = [NSString stringWithFormat:@"%.02f",[model.kdj doubleValue]];;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
