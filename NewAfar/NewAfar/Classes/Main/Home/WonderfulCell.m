//
//  WonderfulCell.m
//  NewAfar
//
//  Created by cw on 17/2/24.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "WonderfulCell.h"

@interface WonderfulCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation WonderfulCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _content.sd_layout.leftSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).autoHeightRatio(0);
}
- (void)configCell:(WorkplaceModel *)model{
    
    if ([model.nr isEqualToString:@""]) {
        _content.hidden = YES;
    }else{
        _content.hidden = NO;
        _content.text = model.nr;
        _content.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    NSArray *arr = [model.tp componentsSeparatedByString:@","];
    [_img sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"place"]];
}
@end
