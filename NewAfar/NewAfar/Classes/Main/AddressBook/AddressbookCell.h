//
//  AddressbookCell.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressbookModel.h"

@interface AddressbookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *postion;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *callClick;
@property (weak, nonatomic) IBOutlet UILabel *phone;
- (void)configCell:(AddressbookModel *)model;

@end
