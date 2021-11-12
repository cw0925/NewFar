//
//  HomeCollectionCell.h
//  AFarSoft
//
//  Created by 陈伟 on 16/7/21.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *title;

- (void)configCollectionCell:(NSIndexPath *)index;
@end
