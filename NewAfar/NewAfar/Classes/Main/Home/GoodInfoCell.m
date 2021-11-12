//
//  GoodInfoCell.m
//  NewAfar
//
//  Created by cw on 17/3/1.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "GoodInfoCell.h"

@interface GoodInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation GoodInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(GoodModel *)model{
    _code.textColor = [UIColor blackColor];
    _name.textColor = [UIColor blackColor];
    
    _code.text = model.gcode;
    _name.text = model.code;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
