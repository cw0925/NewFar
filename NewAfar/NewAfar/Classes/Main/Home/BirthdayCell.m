//
//  BirthdayCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/2.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BirthdayCell.h"

@interface BirthdayCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *birth;
@end

@implementation BirthdayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(BirthModel *)model
{
    _name.text = model.name;
    _birth.text = model.sr;
    if ([model.tx isEqualToString:@""]||[model.tx isEqualToString:@"0"]) {
        _icon.image = [[UIImage imageNamed:@"avatar_zhixing"] circleImage];
    }else{
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.tx] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           _icon.image = [image circleImage];
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
