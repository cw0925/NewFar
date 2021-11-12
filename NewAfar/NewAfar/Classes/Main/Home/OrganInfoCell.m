//
//  OrganInfoCell.m
//  NewAfar
//
//  Created by cw on 17/3/1.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "OrganInfoCell.h"

@interface OrganInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation OrganInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(OrganizationModel *)model{
    _code.textColor = [UIColor blackColor];
    _name.textColor = [UIColor blackColor];
    _code.text = model.c_id;
    _name.text = model.c_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
