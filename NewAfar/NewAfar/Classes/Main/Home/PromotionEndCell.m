//
//  PromotionEndCell.m
//  AfarSoftManager
//
//  Created by 陈伟 on 16/6/30.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "PromotionEndCell.h"

@implementation PromotionEndCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(PromotionModel *)model
{
    _provider.text = model.name;
    _name.text = model.cname;
    _code.text = model.code;
    _type.text = model.cxlx;
    _buyprice.text = [NSString stringWithFormat:@"%.02f元",[model.cxjj doubleValue]];
    _saleprice.text = [NSString stringWithFormat:@"%.02f元",[model.cxsj doubleValue]];
    _plansum.text = [NSString stringWithFormat:@"%.02f",[model.jhcx doubleValue]];
    _actualsum.text = [NSString stringWithFormat:@"%.02f",[model.sjcx doubleValue]];
    _orderdate.text = model.dhedt;
    _promotiondate.text = model.cxedt;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
