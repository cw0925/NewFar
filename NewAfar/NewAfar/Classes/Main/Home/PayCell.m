//
//  PayCell.m
//  NewAfar
//
//  Created by cw on 16/12/17.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "PayCell.h"

@implementation PayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(PayModel *)model
{
    _payID.textColor = [UIColor blackColor];
    _name.textColor = [UIColor blackColor];
    _money.textColor = [UIColor blackColor];
    _cashier.textColor = [UIColor blackColor];
    _date.textColor = [UIColor blackColor];
    
    _payID.text = [NSString stringWithFormat:@"%@%@",model.c_store_id,model.c_storename];
    _name.text = [NSString stringWithFormat:@"%.02f",[model.c_zb doubleValue]];
    _money.text = model.c_name;
    _cashier.text = model.c_type;
    
    if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
        _date.text = [NSString stringWithFormat:@"%.02f",[model.c_amount doubleValue]/10000.0];
    }else{
        _date.text = [NSString stringWithFormat:@"%.02f",[model.c_amount doubleValue]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
