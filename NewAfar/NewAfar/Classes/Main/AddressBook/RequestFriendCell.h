//
//  RequestFriendCell.h
//  NewFarSoft
//
//  Created by CW on 16/8/23.
//  Copyright © 2016年 NewFar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestFriendModel.h"

@interface RequestFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *refuse;
@property (weak, nonatomic) IBOutlet UIButton *agree;
- (void)configCell:(RequestFriendModel *)model;
@end
