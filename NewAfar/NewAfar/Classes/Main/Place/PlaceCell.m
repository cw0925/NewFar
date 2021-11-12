//
//  PlaceCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "PlaceCell.h"
#import "PhotosContainerView.h"
#import "UIButton+LXMImagePosition.h"

#define ImgW (CGRectGetWidth(_bg_imv.frame)-10)/3
#define ImgH CGRectGetHeight(_bg_imv.frame)

@interface PlaceCell ()

@end

@implementation PlaceCell
{
    PhotosContainerView *_photosContainer;
    UILabel *praise_title;
    UILabel *comment_title;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CGFloat margin = 10;
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;
    [self.contentView addSubview:photosContainer];
    
    _content.numberOfLines = 0;
    _content.font = [UIFont systemFontWithSize:13];
    
    _icon.sd_layout.widthIs(40).heightIs(40).leftSpaceToView(self.contentView,margin).topSpaceToView(self.contentView,margin);
    
    _name.textColor = RGBColor(93, 106, 146);
    _name.font = [UIFont systemFontWithSize:13];
    _name.sd_layout.leftSpaceToView(_icon,margin).topSpaceToView(self.contentView,margin).rightSpaceToView(_time,margin).heightIs(20);
    
    _location.font = [UIFont systemFontWithSize:12];
    
    _time.font = [UIFont systemFontWithSize:10];
    
    _time.sd_layout.widthIs(120).heightIs(20).topEqualToView(_name).rightSpaceToView(self.contentView,margin);
    
    _location.sd_layout.leftSpaceToView(_icon,margin).topSpaceToView(_name,5).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _content.sd_layout.leftEqualToView(_name).topSpaceToView(_location,margin).rightSpaceToView(self.contentView,margin).autoHeightRatio(0);
    
    _photosContainer.sd_layout.leftEqualToView(_name).topSpaceToView(_content,10).rightSpaceToView(self.contentView,margin);
}
- (void)setModel:(WorkplaceModel *)model
{
    _model = model;
    
    _name.text = model.name;
    _location.text = model.zw;
    _content.text = model.nr;
    // x分钟前/x小时前/x天前/x个月前/x年前
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate *date =[dateFormat dateFromString:model.sj];
    
    _time.text = [self lastTimeOfChat:date];
    if ([model.tx isEqualToString:@""]||[model.tx isEqualToString:@"0"]) {
        _icon.image = [[UIImage imageNamed:@"avatar_zhixing"] circleImage];
    }else{
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.tx] placeholderImage:[UIImage imageNamed:@"avatar_zhixing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _icon.image = [image circleImage];
        }];
    }
    if ([model.tp isEqualToString:@""]||[model.tp isEqualToString:@"0"]) {
        _photosContainer.hidden = YES;
        
//        _commentBtn.backgroundColor = [UIColor greenColor];
//        _shareBtn.backgroundColor = [UIColor yellowColor];
//        _praiseBtn.backgroundColor = [UIColor purpleColor];
        
        _shareBtn.sd_layout.widthIs(70).heightIs(25).rightSpaceToView(self.contentView,10).topSpaceToView(_content,10);
        
        _praiseBtn.sd_layout.widthIs(60).heightIs(25).rightSpaceToView(_shareBtn,5).topSpaceToView(_content,10);
        
        _commentBtn.sd_layout.widthIs(70).heightIs(25).rightSpaceToView(_praiseBtn,5).topSpaceToView(_content,10);
        
        [_shareBtn updateLayout];
        [_praiseBtn updateLayout];
        [_commentBtn updateLayout];
    }else{
        _photosContainer.hidden = NO;
        NSArray *iconArr = [model.tp componentsSeparatedByString:@","];
        _photosContainer.photoNamesArray = iconArr;
        
//        _shareBtn.backgroundColor = [UIColor redColor];
//        _praiseBtn.backgroundColor = [UIColor orangeColor];
//        _commentBtn.backgroundColor = [UIColor lightGrayColor];
        
        _shareBtn.sd_layout.widthIs(70).heightIs(25).rightSpaceToView(self.contentView,10).topSpaceToView(_photosContainer,10);
        
        _praiseBtn.sd_layout.widthIs(60).heightIs(25).rightSpaceToView(_shareBtn,5).topSpaceToView(_photosContainer,10);
        
        _commentBtn.sd_layout.widthIs(70).heightIs(25).rightSpaceToView(_praiseBtn,5).topSpaceToView(_photosContainer,10);
        
        [_shareBtn updateLayout];
        [_praiseBtn updateLayout];
        [_commentBtn updateLayout];
    }
    
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = [UIFont systemFontWithSize:11];
    [_shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [_shareBtn setImagePosition:LXMImagePositionLeft spacing:5];
    
    [_praiseBtn setTitle:[NSString stringWithFormat:@"赞 %@",model.click] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _praiseBtn.titleLabel.font = [UIFont systemFontWithSize:11];
    [_praiseBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
    [_praiseBtn setImagePosition:LXMImagePositionLeft spacing:5];
    
    [_commentBtn setTitle:[NSString stringWithFormat:@"评论 %@",model.comment] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = [UIFont systemFontWithSize:11];
    [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [_commentBtn setImagePosition:LXMImagePositionLeft spacing:5];
    
    [self setupAutoHeightWithBottomViewsArray:@[_shareBtn,_praiseBtn,_commentBtn] bottomMargin:5];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 计算时间
- (NSString *)lastTimeOfChat:(NSDate *)date {
    
    NSString *str = @" ";
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:date];
    //北京时间加8小时  除以86400得到的是天数
    if ((timeInterval + 60*60*8) / 86400 > 1 && (timeInterval + 60*60*8) / 86400 < 30) {
        
        NSString *min2 =  [NSString stringWithFormat:@"%d天前",(int)(timeInterval + 60*60*8) / 86400];
        str = min2;
    }
    //今天
    else if ((timeInterval + 60*60*8) / 86400 < 1) {
        
        if (timeInterval < 60) {
            str = @"刚刚";
        }
        else if(60 < timeInterval && timeInterval < 3600){
            NSString *min2 =  [NSString stringWithFormat:@"%d分钟前",(int)timeInterval/60];
            str = min2;
        }
        else{
            NSString *min2 =  [NSString stringWithFormat:@"%d小时前",(int)timeInterval/60/60];
            str = min2;
        }
    }
    //一年前
    else if ((timeInterval + 60*60*8) / 2592000 >12){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        str = [dateFormatter stringFromDate:date];
    }
    //一个月前
    else if ((timeInterval + 60*60*8) / 86400 > 30) {
        NSString *min2 =  [NSString stringWithFormat:@"%d月前",(int)(timeInterval + 60*60*8) / 2592000];
        str = min2;
    }
    return str;
}
@end
