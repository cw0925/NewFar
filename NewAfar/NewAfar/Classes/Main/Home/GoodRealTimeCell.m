//
//  GoodRealTimeCell.m
//  AfarSoftManager
//
//  Created by 陈伟 on 16/5/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "GoodRealTimeCell.h"

@implementation GoodRealTimeCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configCell:(GoodModel*)model
{
    _gcode.text = model.gcode;
    _barcode.text = model.barcode;
    _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]];
    _rate.text = [NSString stringWithFormat:@"%.02f",[model.mll doubleValue]*100];
    _price.text = [NSString stringWithFormat:@"%.02f",[model.kdj doubleValue]];
    //_ratio.text = model.zb;
    _sum.text = [NSString stringWithFormat:@"%ld",(long)[model.customers integerValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
