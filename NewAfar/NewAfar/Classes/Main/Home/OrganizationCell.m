//
//  OrganizationCell.m
//  AFarSoft
//
//  Created by CW on 16/8/17.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "OrganizationCell.h"

@interface OrganizationCell ()

@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *organizationCode;
@property (weak, nonatomic) IBOutlet UILabel *shopCode;
@property (weak, nonatomic) IBOutlet UILabel *chargePerson;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *distributionDay;

@end

@implementation OrganizationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(OrganizationModel *)model
{
    _adress.text = model.dz;
    _organizationCode.text = model.psjg;
    _shopCode.text = model.c_id;
    _chargePerson.text = model.fzr;
    _phone.text = model.tel;
    _category.text = model.lb;
    _distributionDay.text = model.pszq;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
