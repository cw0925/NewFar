//
//  ManagerCell.m
//  NewAfar
//
//  Created by cw on 16/12/7.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ManagerCell.h"

@interface ManagerCell ()

@property (weak, nonatomic) IBOutlet UILabel *bcustoms;
@property (weak, nonatomic) IBOutlet UILabel *scustoms;
@property (weak, nonatomic) IBOutlet UILabel *ssale;
@property (weak, nonatomic) IBOutlet UILabel *sh;
@property (weak, nonatomic) IBOutlet UILabel *ch;
@end

@implementation ManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(ManagerModel *)model
{
    _bcustoms.text = [NSString stringWithFormat:@"%.02f",[model.bqcustomers floatValue]];
    _scustoms.text = [NSString stringWithFormat:@"%.02f",[model.bqcustomers floatValue]];
    _ssale.text = [NSString stringWithFormat:@"%.02f",[model.sqxs floatValue]];
    _sh.text = [NSString stringWithFormat:@"%.02f",[model.xshb floatValue]];
    _ch.text = [NSString stringWithFormat:@"%.02f",[model.customerhb floatValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
