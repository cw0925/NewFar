//
//  OrganizationModel.h
//  AFarSoft
//
//  Created by CW on 16/8/17.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BaseModel.h"

@interface OrganizationModel : BaseModel

//机构查询
@property(nonatomic,copy)NSString *c_id;
@property(nonatomic,copy)NSString *c_name;
@property(nonatomic,copy)NSString *dz;
@property(nonatomic,copy)NSString *psjg;
@property(nonatomic,copy)NSString *fzr;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *lb;
@property(nonatomic,copy)NSString *pszq;

@end
