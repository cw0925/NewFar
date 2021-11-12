//
//  GoodCell.m
//  AFarSoft
//
//  Created by CW on 16/8/16.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "GoodCell.h"

@interface GoodCell ()
@property (weak, nonatomic) IBOutlet UILabel *goodtype;
@property (weak, nonatomic) IBOutlet UILabel *supplier;
@property (weak, nonatomic) IBOutlet UILabel *brand;
@property (weak, nonatomic) IBOutlet UILabel *barcode;
@property (weak, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *stock;
@property (weak, nonatomic) IBOutlet UILabel *salevolume;
@property (weak, nonatomic) IBOutlet UILabel *retail;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *specifications;
@property (weak, nonatomic) IBOutlet UILabel *sale;
@property (weak, nonatomic) IBOutlet UILabel *purchase;
@property (weak, nonatomic) IBOutlet UILabel *retailprice;
@property (weak, nonatomic) IBOutlet UILabel *member;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *wholesale;
@property (weak, nonatomic) IBOutlet UILabel *jj;

@end

@implementation GoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(GoodModel *)model
{
    _goodtype.text = [NSString stringWithFormat:@"%@ %@",model.splb,model.lbmc];
    _supplier.text = [NSString stringWithFormat:@"%@ %@",model.gys,model.gysmc];
    _brand.text = [NSString stringWithFormat:@"%@ %@",model.pp,model.PPMC];
    _barcode.text = model.barcode;
    _depart.text = [NSString stringWithFormat:@"%@ %@",model.bm,model.bmmc];
    _place.text = [NSString stringWithFormat:@"%@ %@",model.cd,model.cdmc];
    _stock.text = model.cur_number;
    _salevolume.text = model.sale_number;
    _retail.text = model.cur_rec;
    _date.text = model.last_saleday;
    _specifications.text = model.gg;
    _sale.text = model.xsdw;
    _purchase.text = model.jhdw;
    _retailprice.text = [NSString stringWithFormat:@"%.02f",[model.lsj doubleValue]];
    _member.text = [NSString stringWithFormat:@"%.02f",[model.hyj doubleValue]];
    _discount.text = [NSString stringWithFormat:@"%.02f",[model.zkj doubleValue]];
    _wholesale.text = [NSString stringWithFormat:@"%.02f",[model.pfj doubleValue]];
    _jj.text = [NSString stringWithFormat:@"%.02f",[model.jj doubleValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
