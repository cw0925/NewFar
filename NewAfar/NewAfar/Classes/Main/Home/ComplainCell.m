//
//  ComplainCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/8.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ComplainCell.h"

#define ItemW (self.frame.size.width-3*margin)/2

@interface ComplainCell ()

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *reason;
@property (weak, nonatomic) IBOutlet UILabel *compensate;
@property (weak, nonatomic) IBOutlet UILabel *bear;
@property (weak, nonatomic) IBOutlet UILabel *staff;
@property (weak, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *opinion;
@property (weak, nonatomic) IBOutlet UILabel *charge;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *suggest;
@property (weak, nonatomic) IBOutlet UILabel *result;

@property (weak, nonatomic) IBOutlet UILabel *wire;
@property (weak, nonatomic) IBOutlet UILabel *thread;

@end

@implementation ComplainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat margin = 10.0;
    
    _date.font = [UIFont systemFontWithSize:14];
    
    _state.font = [UIFont systemFontWithSize:14];
    
    _type.font = [UIFont systemFontWithSize:13];
    
    _reason.font = [UIFont systemFontWithSize:13];
    
    _compensate.font = [UIFont systemFontWithSize:13];
    
    _bear.font = [UIFont systemFontWithSize:13];
    
    _staff.font = [UIFont systemFontWithSize:13];
    
    _depart.font = [UIFont systemFontWithSize:13];
    
    _opinion.font = [UIFont systemFontWithSize:13];
    
    _charge.font = [UIFont systemFontWithSize:13];
    
    _name.font = [UIFont systemFontWithSize:13];
    
    _result.textColor = RGBColor(112, 110, 110);
    _result.font = [UIFont systemFontWithSize:13];
    _result.text = @"--处理结果--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    _result.lineBreakMode = NSLineBreakByCharWrapping;
    
    _suggest.text = @"--主管意见-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    _suggest.textColor = RGBColor(112, 110, 110);
    _suggest.font = [UIFont systemFontWithSize:13];
    _suggest.lineBreakMode = NSLineBreakByCharWrapping;
    
    _state.sd_layout.topSpaceToView(self.contentView,margin).rightSpaceToView(self.contentView,margin).widthIs(60).heightIs(20);
    
    _date.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(self.contentView,margin).rightSpaceToView(_state,margin).heightIs(20);
    
    _line.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_date,margin).rightSpaceToView(self.contentView,0).heightIs(1);
    
    _type.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_line,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _reason.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_type,margin).rightSpaceToView(self.contentView,margin).autoHeightRatio(0);
    
    _result.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_reason,margin).rightSpaceToView(self.contentView,0).heightIs(20);
    
    _compensate.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_result,margin).heightIs(20).widthIs(ItemW);
    
    _bear.sd_layout.leftSpaceToView(_compensate,margin).topSpaceToView(_result,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _staff.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_compensate,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _depart.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_staff,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _opinion.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_depart,margin).rightSpaceToView(self.contentView,margin).autoHeightRatio(0);
    
    _suggest.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_opinion,margin).rightSpaceToView(self.contentView,0).heightIs(20);
    
    _charge.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_suggest,margin).rightSpaceToView(self.contentView,margin).autoHeightRatio(0);
    
    _name.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_charge,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _wire.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_name,margin).rightSpaceToView(self.contentView,0).heightIs(1);
    
    _read.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_wire,0).heightIs(40).widthRatioToView(self,0.5);
    
    _comment.sd_layout.topSpaceToView(_wire,0).rightSpaceToView(self.contentView,0).heightIs(40).widthRatioToView(self,0.5);
    
    _thread.sd_layout.leftSpaceToView(_read,0).topSpaceToView(_wire,5).widthIs(1).rightSpaceToView(_comment,0).bottomSpaceToView(self.contentView,5);
    
    [self setupAutoHeightWithBottomViewsArray:@[_read,_comment] bottomMargin:0];
}
- (void)setModel:(ComplainModel *)model
{
    _model = model;
    _date.text = model.date;
    _state.text = model.status;
    if ([model.status isEqualToString:@"未处理"]) {
        _state.textColor = [UIColor redColor];
    }else{
        _state.textColor = RGBColor(192, 110, 53);
    }
    _type.text = [NSString stringWithFormat:@"类型：%@",model.yy];
    _reason.text = model.program;
    _compensate.text = [NSString stringWithFormat:@"补偿方法：%@",model.btype];
    _bear.text = [NSString stringWithFormat:@"承担类型：%@",model.bc];
    _staff.text = [NSString stringWithFormat:@"被投诉：%@",model.hname];
    _depart.text = [NSString stringWithFormat:@"部门：%@",model.bm];
    _opinion.text = model.uyj;
    _charge.text = model.byj;
    _name.text = [NSString stringWithFormat:@"录入人：%@",model.wname];
    [_read setTitle:[NSString stringWithFormat:@"阅读 %@",model.ynum] forState:UIControlStateNormal];
    [_comment setTitle:[NSString stringWithFormat:@"评论 %@",model.pnum] forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
