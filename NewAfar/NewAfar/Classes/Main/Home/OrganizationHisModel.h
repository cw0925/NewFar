//
//  OrganizationHisModel.h
//  NewAfar
//
//  Created by cw on 16/12/15.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseModel.h"

@interface OrganizationHisModel : BaseModel

@property(nonatomic,copy)NSString *c_store_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *amt;
@property(nonatomic,copy)NSString *cxamt;
@property(nonatomic,copy)NSString *ml;
@property(nonatomic,copy)NSString *mll;
@property(nonatomic,copy)NSString *customers;
@property(nonatomic,copy)NSString *kdj;

@property(nonatomic,copy)NSString *C_adno;
@property(nonatomic,copy)NSString *storeid;
@property(nonatomic,copy)NSString *storename;
@end