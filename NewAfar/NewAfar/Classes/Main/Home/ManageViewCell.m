//
//  ManageViewCell.m
//  NewAfar
//
//  Created by cw on 16/12/7.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ManageViewCell.h"

@interface ManageViewCell ()

@end

@implementation ManageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(ManagerModel *)model
{
    _date.textColor = [UIColor blackColor];
    _bs.textColor = [UIColor blackColor];
    _bc.textColor = [UIColor blackColor];
    
    NSArray *arr = [model.date componentsSeparatedByString:@"T"];
    _date.text = arr[0];
    if ([[userDefault valueForKey:@"unit"] isEqualToString:@"2"]) {
        _bs.text = [NSString stringWithFormat:@"%.02f",[model.bqxs doubleValue]/10000.0];
    }else{
        _bs.text = [NSString stringWithFormat:@"%.02f",[model.bqxs doubleValue]];
    }
    //_ss.text = [NSString stringWithFormat:@"%.02f",[model.sqxs doubleValue]/10000];
    _bc.text = [NSString stringWithFormat:@"%ld",(long)[model.bqcustomers integerValue]];
    //_sc.text = [NSString stringWithFormat:@"%ld",(long)[model.sqcustomers integerValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
