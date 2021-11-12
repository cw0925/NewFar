//
//  RatioCell.m
//  AFarSoft
//
//  Created by CW on 16/8/17.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "RatioCell.h"

@interface RatioCell ()
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *profitrate;
@property (weak, nonatomic) IBOutlet UILabel *promotionrate;

@end
@implementation RatioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(OrganizationProModel *)model
{
    _profit.text = [NSString stringWithFormat:@"%.02f",[model.cxml doubleValue]];
    _rate.text = [NSString stringWithFormat:@"%.02f",[model.cxmll doubleValue]*100];
    _profitrate.text = [NSString stringWithFormat:@"%.02f",[model.cxmlzb doubleValue]*100];
    _promotionrate.text = [NSString stringWithFormat:@"%.02f",[model.cxzb doubleValue]*100];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
