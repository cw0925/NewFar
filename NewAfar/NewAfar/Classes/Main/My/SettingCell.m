//
//  SettingCell.m
//  AFarSoft
//
//  Created by 陈伟 on 16/7/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configCell:(NSIndexPath *)index
{
    _title.font = [UIFont systemFontWithSize:13];
    if (index.section == 0) {
        if (index.row <5) {
            NSArray *titleArr = @[@"修改密码",@"绑定企业",@"客服热线",@"常见问题",@"意见反馈"];
            NSArray *picArr = @[@"modify",@"cellphone",@"business",@"hotline",@"problem",@"idea"];
            _title.text = titleArr[index.row];
            _pic.image = [UIImage imageNamed:picArr[index.row]];
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        _pic.image = [UIImage imageNamed:@"exit"];
        _title.text = @"退出登录";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
