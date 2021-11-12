//
//  ManageLeftCell.m
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ManageLeftCell.h"

@implementation ManageLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(ManageHisModel *)model
{
    _depart.textColor = [UIColor blackColor];
    _deadline.textColor = [UIColor blackColor];
    _type.textColor = [UIColor blackColor];
    _rpeople.textColor = [UIColor blackColor];
    _date.textColor = [UIColor blackColor];
    _mpeople.textColor = [UIColor blackColor];
    _state.textColor = [UIColor blackColor];
    
    _depart.text = model.bm;
    _deadline.text = model.rq;
    _type.text = model.type;
    _rpeople.text = model.zrr;
    _date.text = model.date;
    _mpeople.text = model.name;
    _state.text = model.zt;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
