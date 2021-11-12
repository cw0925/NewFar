//
//  CalendarViewController.h
//  AFarSoft
//
//  Created by CW on 16/8/15.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnDate)(NSString *date);

@interface CalendarViewController : BaseViewController

@property (nonatomic, copy) ReturnDate returnDateBlock;

- (void)returnDate:(ReturnDate)dateBlock;

@end
