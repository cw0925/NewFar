//
//  AlbumViewController.h
//  NewAfar
//
//  Created by cw on 16/11/24.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnImgBlock)(NSArray *selArr,NSArray *indexArr);

@interface AlbumViewController : BaseViewController

@property (nonatomic, copy) ReturnImgBlock selBlock;

- (void)returnSelImg:(ReturnImgBlock)block;

@property(nonatomic,assign)NSInteger sum;

@end
