//
//  ProStartDetailCell.m
//  AfarSoftManager
//
//  Created by 陈伟 on 16/7/12.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ProStartDetailCell.h"

@implementation ProStartDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(PromotionModel *)model
{
    _supplier.text = model.name;
    _name.text = model.cname;
    _code.text = model.code;
    _type.text = model.cxlx;
    _buy.text = [NSString stringWithFormat:@"%.02f",[model.cxjj doubleValue]];
    _sale.text = [NSString stringWithFormat:@"%.02f",[model.cxsj doubleValue]];
    _orderDate.text = model.dhsdt;
    _proDate.text = model.cxsdt;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
