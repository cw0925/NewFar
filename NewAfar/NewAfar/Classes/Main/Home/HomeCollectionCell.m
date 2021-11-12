//
//  HomeCollectionCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "HomeCollectionCell.h"

@implementation HomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCollectionCell:(NSIndexPath *)index{
    NSArray *titleArr = @[@"报表中心",@"企业公告",@"精彩分享",@"巡场管理",@"客诉处理",@"工作日志",@"谏言反馈",@"生日提醒",@"零售资讯"];
    NSArray *imgArr = @[@"data",@"announcement",@"share",@"manage",@"complain",@"worklog",@"feedback",@"birth",@"information"];
    _pic.image = [UIImage imageNamed:imgArr[index.item]];
    _title.text = titleArr[index.item];
    _title.font = [UIFont systemFontWithSize:13];
}
@end
