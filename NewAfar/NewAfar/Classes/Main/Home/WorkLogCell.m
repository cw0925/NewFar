//
//  WorkLogCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "WorkLogCell.h"
#import "PhotosContainerView.h"

@implementation WorkLogCell
{
    PhotosContainerView *_photosContainer;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _name.textColor = RGBColor(93, 106, 146);
    _name.font = [UIFont systemFontWithSize:14];
    
    _content.numberOfLines = 0;
    _content.font = [UIFont systemFontWithSize:13];
    
    _postion.font = [UIFont systemFontWithSize:12];
    
    _date.font = [UIFont systemFontWithSize:10];
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;
    [self.contentView addSubview:photosContainer];
    
    _icon.sd_layout.widthIs(40).heightIs(40).topSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10);
    
    _date.sd_layout.widthIs(150).heightIs(20).topSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10);
    
    _name.sd_layout.leftSpaceToView(_icon,10).topSpaceToView(self.contentView,10).rightSpaceToView(_date,10).heightIs(20);
    
    _postion.sd_layout.leftSpaceToView(_icon,10).topSpaceToView(_name,5).rightSpaceToView(self.contentView,10).heightIs(20);
    
    _content.sd_layout.leftEqualToView(_name).topSpaceToView(_postion,10).rightSpaceToView(self.contentView,10).autoHeightRatio(0);
    
    _photosContainer.sd_layout.leftEqualToView(_content).topSpaceToView(_content,10).rightSpaceToView(self.contentView,10);
}
- (void)setModel:(LogModel *)model
{
    _model = model;
    
    if ([model.tx isEqualToString:@""]||[model.tx isEqualToString:@"0"]) {
        _icon.image = [[UIImage imageNamed:@"avatar_zhixing"] circleImage];
    }else{
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.tx] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _icon.image = [image circleImage];
        }];
    }
    _name.text = model.name;
    _postion.text = model.zw;
    NSArray *arr = [model.rq componentsSeparatedByString:@" "];
    _date.text = arr[0];
    _content.text = model.nr;
    //NSLog(@"%@",model.tp);
    UIView *bottomView = _content;

    if (![model.tp isEqualToString:@""]) {
        _photosContainer.hidden = NO;
        NSArray *iconArr = [model.tp componentsSeparatedByString:@","];
        _photosContainer.photoNamesArray = iconArr;
        bottomView = _photosContainer;
    }else {
        _photosContainer.hidden = YES;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 计算时间
//- (NSString *)lastTimeOfChat:(NSDate *)date {
//    
//    NSString *str = @" ";
//    NSDate *nowDate = [NSDate date];
//    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:date];
//    //北京时间加8小时  除以86400得到的是天数
//    if ((timeInterval + 60*60*8) / 86400 > 1 && (timeInterval + 60*60*8) / 86400 < 30) {
//        
//        NSString *min2 =  [NSString stringWithFormat:@"%d天前",(int)(timeInterval + 60*60*8) / 86400];
//        str = min2;
//    }
//    //今天
//    else if ((timeInterval + 60*60*8) / 86400 < 1) {
//        
//        if (timeInterval < 60) {
//            str = @"刚刚";
//        }
//        else if(60 < timeInterval && timeInterval < 3600){
//            NSString *min2 =  [NSString stringWithFormat:@"%d分钟前",(int)timeInterval/60];
//            str = min2;
//        }
//        else{
//            NSString *min2 =  [NSString stringWithFormat:@"%d小时前",(int)timeInterval/60/60];
//            str = min2;
//        }
//    }
//    //一个月前
//    else if ((timeInterval + 60*60*8) / 86400 > 30) {
//        NSString *min2 =  [NSString stringWithFormat:@"%d个月前",(int)(timeInterval + 60*60*8) / 2592000];
//        str = min2;
//    }
//    return str;
//}
@end
