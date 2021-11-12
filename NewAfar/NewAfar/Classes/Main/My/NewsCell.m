//
//  NewsCell.m
//  NewAfar
//
//  Created by cw on 17/2/10.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _name.font = [UIFont systemFontWithSize:14];
    
    _date.font = [UIFont systemFontWithSize:12];
    _date.textAlignment = NSTextAlignmentRight;
    
    _content.font = [UIFont systemFontWithSize:14];
    
    CGFloat margin = 10;
    
    _icon.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(self.contentView,margin).widthIs(30).heightIs(30);
    
    _date.sd_layout.topSpaceToView(self.contentView,2).rightSpaceToView(self.contentView,5).heightIs(30).widthIs(150);
    
    _name.sd_layout.leftSpaceToView(_icon,margin).topSpaceToView(self.contentView,2).rightSpaceToView(_date,margin).heightIs(30);
    
    _content.sd_layout.leftEqualToView(_name).topSpaceToView(_icon,2).rightSpaceToView(self.contentView,margin).autoHeightRatio(0);
}
- (void)setModel:(NewsModel *)model
{
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.c_recaddresszc] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"]];
    
    NSString *date = [model.c_datetime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    _date.text = date;
    
    _name.text = model.c_recrealname;
    
    _content.text = model.c_content;
    
     [self setupAutoHeightWithBottomView:_content bottomMargin:10];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
