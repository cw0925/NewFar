//
//  SettingCell.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *title;
- (void)configCell:(NSIndexPath *)index;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@end
