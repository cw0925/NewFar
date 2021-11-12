//
//  GregorianCalendarViewController.h
//  NewAfar
//
//  Created by cw on 17/2/7.
//  Copyright © 2017年 afarsoft. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnDate)(NSString *date);

@class MonthModel;

@interface GregorianCalendarViewController : BaseViewController

@property (nonatomic, copy) ReturnDate returnDateBlock;

- (void)returnDate:(ReturnDate)dateBlock;

@end
//CollectionViewHeader
@interface CalendarHeaderView : UICollectionReusableView
@end

//UICollectionViewCell
@interface CalendarCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *dayLabel;

@property (strong, nonatomic) MonthModel *monthModel;
@end

//存储模型
@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;
@end