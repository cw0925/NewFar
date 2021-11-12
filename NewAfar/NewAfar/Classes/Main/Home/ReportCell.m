//
//  ReportCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/1.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(ReportModel *)model
{
    _title.font = [UIFont systemFontWithSize:14];
    _content.font = [UIFont systemFontWithSize:13];
    _date.font = [UIFont systemFontWithSize:11];
    
    _content.layer.cornerRadius = 5;
    _content.layer.masksToBounds = YES;
    
    _title.text = model.bt;
    _content.text = [NSString stringWithFormat:@" %@",model.nr];
    _date.text = [NSString stringWithFormat:@"发布于%@ /%@次浏览",model.dt,model.readpeonum];
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
