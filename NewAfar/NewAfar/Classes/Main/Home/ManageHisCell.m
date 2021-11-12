//
//  ManageHisCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ManageHisCell.h"

@interface ManageHisCell ()

@end

@implementation ManageHisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(ManageHisModel *)model
{
    _depart.textColor = [UIColor blackColor];
    _type.textColor = [UIColor blackColor];
    _rpeople.textColor = [UIColor blackColor];
    _punish.textColor = [UIColor blackColor];
    _date.textColor = [UIColor blackColor];
    _mpeople.textColor = [UIColor blackColor];
    _state.textColor = [UIColor blackColor];
    
    _depart.text = model.bm;
    _type.text = model.type;
    _rpeople.text = model.zrr;
    _punish.text = model.cf;
    _date.text = model.date;
    _mpeople.text = model.name;
    _state.text = model.zt;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
