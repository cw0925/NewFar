//
//  PayModel.h
//  NewAfar
//
//  Created by cw on 16/12/17.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import "BaseModel.h"

@interface PayModel : BaseModel

@property(nonatomic,copy)NSString *c_id;
@property(nonatomic,copy)NSString *c_name;
@property(nonatomic,copy)NSString *c_computer_id;
@property(nonatomic,copy)NSString *c_datetime;
@property(nonatomic,copy)NSString *c_cashier;
@property(nonatomic,copy)NSString *c_cardno;
@property(nonatomic,copy)NSString *c_amount;
@property(nonatomic,copy)NSString *c_type;
@property(nonatomic,copy)NSString *c_charger;
@property(nonatomic,copy)NSString *c_identity;
@property(nonatomic,copy)NSString *c_bill_id;
@property(nonatomic,copy)NSString *c_sub_type;
@property(nonatomic,copy)NSString *c_store_id;
@property(nonatomic,copy)NSString *c_storename;
@property(nonatomic,copy)NSString *c_zb;

@end
