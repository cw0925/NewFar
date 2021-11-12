//
//  SupplierModel.h
//  NewAfar
//
//  Created by huanghuixiang on 16/9/5.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseModel.h"

@interface SupplierModel : BaseModel
//供应商数据
@property(nonatomic,copy)NSString *gysno;
@property(nonatomic,copy)NSString *gysname;
@property(nonatomic,copy)NSString *customers;
@property(nonatomic,copy)NSString *amt;
@property(nonatomic,copy)NSString *qty;
@property(nonatomic,copy)NSString *kdj;
@property(nonatomic,copy)NSString *ml;
@property(nonatomic,copy)NSString *mll;

@end
