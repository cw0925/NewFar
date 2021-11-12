//
//  DepartRealCell.m
//  NewAfar
//
//  Created by cw on 16/12/16.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "DepartRealCell.h"

@implementation DepartRealCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(DepartRealModel *)model
{
    _department.text = [NSString stringWithFormat:@"%@ %@",model.C_adno,model.name];
    _sum.text = [NSString stringWithFormat:@"%.02f",[model.amt doubleValue]/10000.0];
    _customs.text = model.customers;
    _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]/10000.0];
    _price.text = [NSString stringWithFormat:@"%.02f",[model.cxamt doubleValue]];
    _sale.text = [NSString stringWithFormat:@"%.02f",[model.cxamt doubleValue]/10000.0];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
