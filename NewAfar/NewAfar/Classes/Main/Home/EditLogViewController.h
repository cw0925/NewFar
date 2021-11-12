//
//  EditLogViewController.h
//  NewAfar
//
//  Created by cw on 17/2/8.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^myBlock)(NSString *str);

@interface EditLogViewController : BaseViewController

// 生成一个 block 属性
@property(nonatomic, copy) myBlock block;

@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *c_newid;

@property(nonatomic,copy)NSString *log_content;

@end
