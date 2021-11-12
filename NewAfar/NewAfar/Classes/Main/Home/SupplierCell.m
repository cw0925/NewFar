//
//  SupplierCell.m
//  NewAfar
//
//  Created by huanghuixiang on 16/9/5.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "SupplierCell.h"

@interface SupplierCell ()
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *customer;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *rate;

@end

@implementation SupplierCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(SupplierModel *)model
{
    _code.text = model.gysno;
    _customer.text = model.customers;
    _sum.text = [NSString stringWithFormat:@"%.02f",[model.qty doubleValue]];
    _price.text = [NSString stringWithFormat:@"%.02f",[model.kdj doubleValue]];
    _profit.text = [NSString stringWithFormat:@"%.02f",[model.ml doubleValue]];
    _rate.text = [NSString stringWithFormat:@"%.02f",[model.mll doubleValue]*100];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
