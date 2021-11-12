//
//  CalendarViewController.m
//  AFarSoft
//
//  Created by CW on 16/8/15.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CalendarViewController.h"
#import "DateCell.h"

#define ItemW _bgDate.frame.size.width
#define ItemH _bgDate.frame.size.height

@interface CalendarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgDate;
- (IBAction)lastMonthClick:(UIButton *)sender;
- (IBAction)nextMonthClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateTitle;


@end

@implementation CalendarViewController
{
    NSArray *titleArr;
    NSMutableArray *allDayArray;
    NSDate *_date;
    UICollectionView *_calendarCollection;
    NSDateFormatter *dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationBar:@"选择日期" hasLeft:YES hasRight:NO withRightBarButtonItemImage:@""];
    [self initUI];
}
- (void)initUI
{
    titleArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5 ;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(ItemW/7 , ItemW/8);
    
    _calendarCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, CGRectGetWidth(_bgDate.frame), ViewHeight) collectionViewLayout:layout];
    _calendarCollection.backgroundColor = [UIColor whiteColor];
    _calendarCollection.delegate = self;
    _calendarCollection.dataSource = self;
    [_bgDate addSubview:_calendarCollection];
    [_calendarCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgDate).with.insets(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
    [_calendarCollection registerNib:[UINib nibWithNibName:@"DateCell" bundle:nil] forCellWithReuseIdentifier:@"dateCell"];
    
    _date = [NSDate date];
    dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    _dateTitle.text = [dateFormatter stringFromDate:_date];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }
    else
    {
        return 42;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dateCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.content.text  = titleArr[indexPath.item];
    }else
    {
        //获得本月第一天在星期几
        allDayArray = [NSMutableArray array];
        
        NSInteger day = [self currentFirstDay:_date];
        for (NSInteger i = 0; i < day; i++){
            [allDayArray addObject:@""];
        }
        
        NSInteger days = [self currentMonthOfDay:_date];
        
        for (NSInteger i = 1; i <= days; i++) {
            //[allDayArray addObject:@(i)];
            [allDayArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        //把剩下的空间置为空
        for (NSInteger i = allDayArray.count; i < 42; i ++) {
            [allDayArray addObject:@""];
        }
        cell.content.text = [NSString stringWithFormat:@"%@",allDayArray[indexPath.row]];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //将当日添加背景
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSArray *arr = [[dateFormatter stringFromDate:_date] componentsSeparatedByString:@"-"];
            if ([cell.content.text isEqualToString:[arr lastObject]]) {
                cell.content.backgroundColor = [UIColor blueColor];
            }
        });
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DateCell *cell = (DateCell *)[collectionView cellForItemAtIndexPath:indexPath];         
    cell.backgroundColor = RGBColor(16, 105, 201);
    NSString *cellString = allDayArray[indexPath.row];
    //NSLog(@"-----:%@",_dateTitle.text);
    NSString *str = [NSString stringWithFormat:@"%@%@日",_dateTitle.text,cellString];
    self.returnDateBlock(str);
    [self.navigationController popViewControllerAnimated:YES];
}
//点击跳转，反向传值
- (void)returnDate:(ReturnDate)dateBlock
{
    self.returnDateBlock = dateBlock;
}
//日期设置
/**
 *  本月第一天是星期几
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)currentFirstDay:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//1.mon
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    //return firstWeekday - 1;
    return firstWeekday;

}
/**
 *  本月又几天
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)currentMonthOfDay:(NSDate *)date{
    
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}
/**
 *  获取当前月的月份
 */
- (NSInteger)currentMonth:(NSDate *)date{
    
    NSDateComponents *componentsMonth = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [componentsMonth month];
}
/**
 *  获取当前月的年份
 */
- (NSInteger)currentYear:(NSDate *)date{
    
    NSDateComponents *componentsYear = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [componentsYear year];
}
/**
 *  获取当前是哪一天
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)currentDay:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//上个月
- (IBAction)lastMonthClick:(UIButton *)sender {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:_date options:0];
    [self setShowDateLabelString:newDate];
    _date = newDate;
    [_calendarCollection reloadData];
}
//下个月
- (IBAction)nextMonthClick:(UIButton *)sender {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:_date options:0];
    [self setShowDateLabelString:newDate];
    _date = newDate;
    [_calendarCollection reloadData];
}
/**
 *  label的set方法
 *
 *  @param showDateLabel <#showDateLabel description#>
 */
- (void)setShowDateLabelString:(NSDate *)date{
    
    _dateTitle.text = [NSString stringWithFormat:@"%li年%li月",(long)[self currentYear:date],(long)[self currentMonth:date]];
}
@end
