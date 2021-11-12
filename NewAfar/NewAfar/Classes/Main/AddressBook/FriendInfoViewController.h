//
//  FriendInfoViewController.h
//  NewAfar
//
//  Created by cw on 17/2/16.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressbookModel.h"

@interface FriendInfoViewController : BaseViewController

@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *type;//none、callPhone、addFriend
@property(nonatomic,strong)AddressbookModel *model;

@end
