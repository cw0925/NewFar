//
//  AddressbookCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "AddressbookCell.h"

@implementation AddressbookCell
{
    BOOL isFocus;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(AddressbookModel *)model
{
    isFocus = NO;
    if ([model.gztype isEqualToString:@"0"]) {
        isFocus = NO;
    }else{
        isFocus = YES;
    }
    if ([model.isfriend isEqualToString:@"0"]) {
        _phone.hidden = YES;
        [_callClick setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    }else{
        _phone.hidden = NO;
        [_callClick setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        [_callClick setBackgroundImage:[UIImage imageNamed:@"redheart"] forState:UIControlStateSelected];
    }
    
    _postion.text = model.zw;
    _postion.font = [UIFont systemFontWithSize:12];
    _name.text = model.name;
    _name.font = [UIFont systemFontWithSize:14];
    _phone.text = model.tel;
    _phone.font = [UIFont systemFontWithSize:12];
    _callClick.selected = isFocus;
    if ([model.tx isEqualToString:@""]) {
        _icon.image = [[UIImage imageNamed:@"avatar_zhixing"] circleImage];
    }else{
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.tx] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _icon.image = [image circleImage];
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
