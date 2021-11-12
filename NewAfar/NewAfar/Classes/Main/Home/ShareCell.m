//
//  ShareCell.m
//  NewAfar
//
//  Created by cw on 16/11/23.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "ShareCell.h"
#import "PhotosContainerView.h"

@implementation ShareCell
{
    UIImageView *_icon;
    UILabel *_name;
    UILabel *_date;
    UILabel *_postion;
    UILabel *_content;
    PhotosContainerView *_photosContainer;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    _icon = [UIImageView new];
    
    _name = [UILabel new];
    _name.font = [UIFont systemFontWithSize:14];
    _name.textColor = RGBColor(93, 106, 146);
    
    _date = [UILabel new];
    _date.textColor = [UIColor lightGrayColor];
    _date.font = [UIFont systemFontWithSize:10];
    //_date.backgroundColor = [UIColor purpleColor];
    _date.textAlignment = NSTextAlignmentRight;
    
    _postion = [UILabel new];
    _postion.textColor = [UIColor lightGrayColor];
    _postion.font = [UIFont systemFontWithSize:12];
    //_postion.backgroundColor = [UIColor redColor];
    
    _content = [UILabel new];
    _content.numberOfLines = 0;
    _content.font = [UIFont systemFontWithSize:13];
    
    CGFloat margin = 10;
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;
    
    NSArray *views = @[_icon,_name,_date,_postion,_content,_photosContainer];
    [self.contentView sd_addSubviews:views];
    
    _icon.sd_layout.widthIs(40).heightIs(40).topSpaceToView(self.contentView,margin).leftSpaceToView(self.contentView,margin);
    
   // _date.backgroundColor = [UIColor redColor];
    _date.sd_layout.rightSpaceToView(self.contentView,margin).topSpaceToView(self.contentView,margin).widthIs(140).heightIs(20);
    
   // _name.backgroundColor = [UIColor greenColor];
    _name.sd_layout.leftSpaceToView(_icon,margin).topSpaceToView(self.contentView,margin).rightSpaceToView(_date,margin).heightIs(20);
    
   // _postion.backgroundColor = [UIColor purpleColor];
    _postion.sd_layout.leftSpaceToView(_icon,margin).topSpaceToView(_name,5).rightSpaceToView(self.contentView,margin).heightIs(20);
    
    _content.sd_layout.leftEqualToView(_name).topSpaceToView(_postion,margin).rightSpaceToView(self.contentView,margin).autoHeightRatio(0);
    
    _photosContainer.sd_layout.leftEqualToView(_name).topSpaceToView(_content,margin).rightSpaceToView(self.contentView,margin);
    
    [self setupAutoHeightWithBottomViewsArray:@[_content,_photosContainer] bottomMargin:margin];
}

- (void)setModel:(WorkplaceModel *)model
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
    _content.text = model.nr;
    
    // x分钟前/x小时前/x天前/x个月前/x年前
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate *date =[dateFormat dateFromString:model.sj];
    
    _date.text = [self lastTimeOfChat:date];
    
    UIView *bottomView = _content;
    
    if ([model.tp isEqualToString:@""]||[model.tp isEqualToString:@"0"]) {
        _photosContainer.hidden = YES;
    }else{
        _photosContainer.hidden = NO;
        NSArray *iconArr = [model.tp componentsSeparatedByString:@","];
        _photosContainer.photoNamesArray = iconArr;
        bottomView = _photosContainer;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
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
    }//一年后
    else if ((timeInterval + 60*60*8) / 2592000 > 12){
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
