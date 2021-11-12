//
//  MyAttentionCell.m
//  NewFarSoft
//
//  Created by CW on 16/8/24.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "MyAttentionCell.h"

@interface MyAttentionCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation MyAttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(AttentionModel *)model
{
    _name.text = [NSString stringWithFormat:@" %@  (%@)",model.name,model.nc];
    _name.font = [UIFont systemFontWithSize:13];
    _phone.text = model.tel;
    _phone.font = [UIFont systemFontWithSize:12];
    
    if ([model.tx isEqualToString:@""]||[model.tx isEqualToString:@"0"]) {
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
