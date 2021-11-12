//
//  MoreCell.m
//  NewAfar
//
//  Created by cw on 17/2/21.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "MoreCell.h"

@interface MoreCell ()
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation MoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(MoreModel *)model{
     NSString *date = [model.dt stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    _date.text = date;
    _name.text = model.c_real_name;
    
    _date.font = [UIFont systemFontWithSize:12];
    _name.font = [UIFont systemFontWithSize:14];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
