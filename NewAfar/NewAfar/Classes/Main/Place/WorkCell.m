//
//  WorkCell.m
//  NewAfar
//
//  Created by cw on 16/12/13.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "WorkCell.h"
#import "PhotosContainerView.h"

#define ImgW (CGRectGetWidth(_bg_imv.frame)-10)/3
#define ImgH CGRectGetHeight(_bg_imv.frame)

@implementation WorkCell
{
    UIImageView *_icon;
    UILabel *_name;
    UILabel *_location;
    UILabel *_time;
    UILabel *_content;
    PhotosContainerView *_photosContainer;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    CGFloat margin = 10;
    
    _icon = [UIImageView new];
    
    _name = [UILabel new];
    
    _location = [UILabel new];
    _location.textColor = [UIColor lightGrayColor];
    _location.font = [UIFont systemFontOfSize:12];
    
    _time = [UILabel new];
    _time.textColor = [UIColor lightGrayColor];
    _time.font = [UIFont systemFontOfSize:12];
    
    _content = [UILabel new];
    _content.numberOfLines = 0;
    _content.font = [UIFont systemFontOfSize:12];
    
    _commentBtn = [UIButton new];
    [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [_commentBtn setBackgroundColor:[UIColor redColor]];
    
    _shareBtn = [UIButton new];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setBackgroundColor:[UIColor greenColor]];
    
    _praiseBtn = [UIButton new];
    [_praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
    [_praiseBtn setBackgroundColor:[UIColor purpleColor]];
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;
    
    [self.contentView sd_addSubviews:@[_icon,_photosContainer,_name,_location,_time,_content,_commentBtn,_shareBtn,_praiseBtn]];
    
    _content.numberOfLines = 0;
    
    _icon.sd_layout.widthIs(40).heightIs(40).leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10);
    
    _name.sd_layout.leftSpaceToView(_icon,10).topSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(20);
    
    _time.sd_layout.widthIs(150).heightIs(20).topSpaceToView(_name,5).rightSpaceToView(self.contentView,10);
    
    _location.sd_layout.leftSpaceToView(_icon,10).topSpaceToView(_name,5).rightSpaceToView(self.contentView,10).heightIs(20);
    
    _content.sd_layout.leftEqualToView(_name).topSpaceToView(_location,10).rightSpaceToView(self.contentView,10).autoHeightRatio(0.1);
    
    _photosContainer.sd_layout.leftEqualToView(_name).topSpaceToView(_content,10).rightSpaceToView(self.contentView,10);
    
    
    _shareBtn.sd_layout.widthIs(50).heightIs(20).rightSpaceToView(self.contentView,margin).topSpaceToView(_photosContainer,5);
    
    _praiseBtn.sd_layout.widthIs(50).heightIs(20).rightSpaceToView(_shareBtn,5).topSpaceToView(_photosContainer,5);
    
    _commentBtn.sd_layout.widthIs(50).heightIs(20).rightSpaceToView(_praiseBtn,5).topSpaceToView(_photosContainer,5);
    
     [self setupAutoHeightWithBottomView:_commentBtn bottomMargin:margin];
}

- (void)configCell:(WorkplaceModel *)model
{
    _workModel = model;
    
    _name.text = model.name;
    _location.text = model.c_no;
    _content.text = model.nr;
    _time.text = model.sj;
    
    NSString *str = model.tx;
    NSString *tx = [str stringByReplacingOccurrencesOfString:@"app.afarsoft.com" withString:@"192.168.0.54:8894"];
    //NSLog(@"%@",tx);
    [_icon sd_setImageWithURL:[NSURL URLWithString:tx] placeholderImage:[UIImage imageNamed:@"personicon.jpg"]];
    
    NSArray *iconArr = [model.tp componentsSeparatedByString:@","];
    NSLog(@"%lu",(unsigned long)iconArr.count);
    _photosContainer.photoNamesArray = iconArr;
    if (iconArr.count > 0) {
        _photosContainer.hidden = NO;
    } else {
        _photosContainer.hidden = YES;
    }
    
    //[self setupAutoHeightWithBottomView:_commentBtn bottomMargin:10];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
