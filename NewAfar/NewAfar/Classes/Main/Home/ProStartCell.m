//
//  ProStartCell.m
//  AfarSoftManager
//
//  Created by 陈伟 on 16/7/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ProStartCell.h"

@implementation ProStartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(PromotionModel *)model
{
    _title.text = [NSString stringWithFormat:@"   部门：    %@",model.adno];
    _desc.text = [NSString stringWithFormat:@"   促销商品数量：  %@",model.qty];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
