//
//  ManageCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/5.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "ManageCell.h"
#import "PhotosContainerView.h"

@interface ManageCell ()

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *measure;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *reason;
@property (weak, nonatomic) IBOutlet UILabel *responsible;
@property (weak, nonatomic) IBOutlet UILabel *depart;
@property (weak, nonatomic) IBOutlet UILabel *check;
@property (weak, nonatomic) IBOutlet UILabel *manage;
@property (weak, nonatomic) IBOutlet UILabel *line;

@property(nonatomic,copy)NSMutableArray *separatorViewArr;
@end

@implementation ManageCell
{
    PhotosContainerView *_photosContainer;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _date.font = [UIFont systemFontWithSize:14];
    _reason.font = [UIFont systemFontWithSize:14];
    _state.font = [UIFont systemFontWithSize:14];
    
    _type.font = [UIFont systemFontWithSize:12];
    _measure.font = [UIFont systemFontWithSize:12];
    _responsible.font = [UIFont systemFontWithSize:12];
    _depart.font = [UIFont systemFontWithSize:12];
    _check.font = [UIFont systemFontWithSize:12];
    _manage.font = [UIFont systemFontWithSize:12];
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    photosContainer.backgroundColor = [UIColor whiteColor];
    _photosContainer = photosContainer;
    [self.contentView addSubview:photosContainer];
    
    CGFloat margin = 10.0;
    
    _state.sd_layout.topSpaceToView(self.contentView,margin).rightSpaceToView(self.contentView,margin).heightIs(30).widthIs(60);
    
    _date.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(self.contentView,margin).rightSpaceToView(_state,margin).heightIs(30);
    
    _line.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_date,margin).rightSpaceToView(self.contentView,0).heightIs(1);
    
    _measure.sd_layout.topSpaceToView(_line,margin).rightSpaceToView(self.contentView,margin).widthIs(60).heightIs(20);
    
    _type.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_line,margin).rightSpaceToView(_measure,margin).heightIs(20);
    
    _reason.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_type,margin).rightSpaceToView(self.contentView,margin).autoHeightRatio(0);
    
    _photosContainer.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_reason,margin).rightSpaceToView(self.contentView,margin);
    
    _responsible.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_photosContainer,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _depart.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_responsible,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _check.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_depart,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _manage.sd_layout.leftSpaceToView(self.contentView,margin).topSpaceToView(_check,margin).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    [self setupAutoHeightWithBottomView:_manage bottomMargin:5];
}
- (void)setModel:(ManagingModel *)model
{
    _model = model;
    
    _date.text = model.rq;
    _state.text = model.zt;
    if ([model.zt isEqualToString:@"未处理"]) {
        _state.textColor = [UIColor redColor];
    }else{
        _state.textColor = RGBColor(192, 110, 53);
    }
    _type.text = [NSString stringWithFormat:@"类型：%@",model.type];
    //添加文字颜色
//    if (![model.clx isEqualToString:@""]) {
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:model.clx];
//        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1,model.clx.length-2)];
//        _measure.attributedText  = attrStr;
//    }
    _measure.text = model.clx;
    
    _reason.text = model.nr;
    _check.text = [NSString stringWithFormat:@"复查时间：%@",model.fcdate];
    _responsible.text = [NSString stringWithFormat:@"责任人：%@",model.zrr];
    _depart.text = [NSString stringWithFormat:@"部门：%@",model.bm];
    _manage.text = [NSString stringWithFormat:@"巡场人：%@",model.xcr];
    if ([model.xctp isEqualToString:@""]||[model.xctp isEqualToString:@"0"]) {
        _photosContainer.hidden = YES;
        [_responsible updateLayout];
        _responsible.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(_reason,10).rightSpaceToView(self.contentView,10).heightIs(20);
    }else{
        _photosContainer.hidden = NO;
        NSArray *iconArr = [model.xctp componentsSeparatedByString:@","];
        _photosContainer.photoNamesArray = iconArr;
        [_responsible updateLayout];
        _responsible.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(_photosContainer,10).rightSpaceToView(self.contentView,10).heightIs(20);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (self.editing) {
        for (UIView *view in self.subviews) {
            if ([view isMemberOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
                //NSLog(@"%@",NSStringFromClass([view class]))
                //view.backgroundColor = [UIColor whiteColor];
                [self.separatorViewArr addObject:view];
            }
        }
    }
    UIView *selectView = _separatorViewArr[0];
    selectView.backgroundColor = [UIColor clearColor];

}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
   // NSLog(@"setHighlighted");
    return;
}
- (NSMutableArray *)separatorViewArr
{
    if (!_separatorViewArr) {
        _separatorViewArr = [NSMutableArray array];
    }
    return _separatorViewArr;
}
@end
