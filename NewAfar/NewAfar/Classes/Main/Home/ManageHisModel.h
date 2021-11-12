//
//  ManageHisModel.h
//  AFarSoft
//
//  Created by 陈伟 on 16/8/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BaseModel.h"

@interface ManageHisModel : BaseModel
//巡场历史
@property(nonatomic,copy)NSString *c_id;
@property(nonatomic,copy)NSString *bm;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *zrr;
@property(nonatomic,copy)NSString *cf;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *zt;
//巡场遗留
@property(nonatomic,copy)NSString *rq;

@end
