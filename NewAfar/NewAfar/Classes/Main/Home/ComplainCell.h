//
//  ComplainCell.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/8.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainModel.h"

@interface ComplainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *read;
@property (weak, nonatomic) IBOutlet UIButton *comment;

@property(nonatomic,strong)ComplainModel *model;

@end
