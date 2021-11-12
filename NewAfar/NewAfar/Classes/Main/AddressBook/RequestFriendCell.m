//
//  RequestFriendCell.m
//  NewFarSoft
//
//  Created by CW on 16/8/23.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import "RequestFriendCell.h"

@implementation RequestFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(RequestFriendModel *)model
{
    _name.text = [NSString stringWithFormat:@"昵称：%@",model.nc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
