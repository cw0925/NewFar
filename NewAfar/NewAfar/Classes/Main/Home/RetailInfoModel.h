//
//  RetailInfoModel.h
//  NewAfar
//
//  Created by cw on 16/11/8.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseModel.h"

@interface RetailInfoModel : BaseModel

@property(nonatomic,copy)NSString *c_id;
@property(nonatomic,copy)NSString *c_title;
@property(nonatomic,copy)NSString *c_content;
@property(nonatomic,copy)NSString *c_dt;
@property(nonatomic,copy)NSString *ifread;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *readpeonum;

@end
