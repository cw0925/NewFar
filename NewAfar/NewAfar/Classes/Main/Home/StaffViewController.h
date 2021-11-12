//
//  StaffViewController.h
//  NewAfar
//
//  Created by CW on 2017/4/10.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnSelectName)(NSArray *selectArr,NSArray *statueArr);

@interface StaffViewController : BaseViewController

@property (nonatomic, copy) ReturnSelectName returnName;

- (void)returnName:(ReturnSelectName)block;

@property (nonatomic, copy) NSArray *indexArr;
@end
