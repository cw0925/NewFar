//
//  ReportModel.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/1.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BaseModel.h"

@interface ReportModel : BaseModel

@property(nonatomic,copy)NSString *c_id;
@property(nonatomic,copy)NSString *bt;
@property(nonatomic,copy)NSString *dt;
@property(nonatomic,copy)NSString *nr;
@property(nonatomic,copy)NSString *c_type;
@property(nonatomic,copy)NSString *ifread;
@property(nonatomic,copy)NSString *readpeonum;

@end
