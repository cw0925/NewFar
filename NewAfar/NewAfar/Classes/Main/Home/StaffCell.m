//
//  StaffCell.m
//  NewAfar
//
//  Created by CW on 2017/4/10.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "StaffCell.h"

@interface StaffCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *postion;

@end

@implementation StaffCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(StaffModel *)model{
    if ([model.c_addresszc isEqualToString:@""]||[model.c_addresszc isEqualToString:@"0"]) {
        _icon.image = [UIImage imageNamed:@"avatar_zhixing"];
    }else{
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.c_addresszc] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _icon.image = [image circleImage];
        }];
    }
    _name.text = model.c_real_name;
    _name.font = [UIFont systemFontWithSize:14];
    _postion.text = model.c_position;
    _postion.font = [UIFont systemFontWithSize:12];
    _flag.tintColor = [UIColor clearColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
