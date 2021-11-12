//
//  ManageViewCell.h
//  NewAfar
//
//  Created by cw on 16/12/7.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerModel.h"

@interface ManageViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *bs;
@property (weak, nonatomic) IBOutlet UILabel *ss;
@property (weak, nonatomic) IBOutlet UILabel *bc;
@property (weak, nonatomic) IBOutlet UILabel *sc;

- (void)configCell:(ManagerModel *)model;
@end
