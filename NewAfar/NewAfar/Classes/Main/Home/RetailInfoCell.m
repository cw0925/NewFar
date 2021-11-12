//
//  RetailInfoCell.m
//  NewAfar
//
//  Created by cw on 16/11/8.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "RetailInfoCell.h"

@interface RetailInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *isRead;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end

@implementation RetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(RetailInfoModel *)model
{
    _title.font = [UIFont systemFontWithSize:13];
    _content.font = [UIFont systemFontWithSize:12];
    _date.font = [UIFont systemFontWithSize:10];
    _type.font = [UIFont systemFontWithSize:10];
    
    _type.textColor = RGBColor(110, 111, 113);
    _date.textColor = RGBColor(110, 111, 113);
    
    _type.text = [NSString stringWithFormat:@"所属栏目:%@ /%@次浏览",model.type,model.readpeonum];
    
    _title.text = model.c_title;
    NSArray *arr = [model.c_dt componentsSeparatedByString:@"T"];
    _date.text = arr[0];
    _content.text = model.c_content;
    if ([model.ifread isEqualToString:@"1"]) {
        _isRead.hidden = YES;
    }else{
        _isRead.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
