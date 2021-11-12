//
//  DatePickView.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/3.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "DatePickView.h"

#define BGHeight 40

@interface DatePickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,copy)NSMutableArray *yearArr;
@property(nonatomic,copy)NSMutableArray *monthArr;
@property(nonatomic,copy)NSMutableArray *dayArr;

@end

@implementation DatePickView
{
    UIView *bg;
    UIPickerView *pick;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createDateData];
    }
    return self;
}
//数据
- (void)createDateData
{
    //年
    for (NSInteger i = 1916; i< 2117; i++) {
        [self.yearArr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    //月
    for (NSInteger i = 1; i < 13; i++) {
        [self.monthArr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    //日 |1、3、5、7、8、10、12 （31)| 2 (28/29)|4,6,9,11(30)
    for (NSInteger i = 1; i < 32; i++) {
        [self.dayArr addObject:[NSString stringWithFormat:@"%ld",(long)i]];//31
    }

}
- (void)setUpPickView
{
    //toolbar
    bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, BGHeight)];
    bg.backgroundColor = RGBColor(239, 240, 240);
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 80, BGHeight);
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:left];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(left.frame), 0, bg.frame.size.width-160, BGHeight)];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = RGBColor(75, 110, 216);
    [bg addSubview:_title];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(bg.frame.size.width - 80, 0, 80, BGHeight);
    [right setTitle:@"确定" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:right];
    
    //选择器
    pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
//    pick = [[UIPickerView alloc] initWithFrame:CGRectZero];
//    
//    pick.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; //这里设置了就可以自定                                                                                                                           义高度了，一般默认是无法修改其216像素的高度
//    
//    pick.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216);
//    
//    pick.showsSelectionIndicator = YES;    //这个最好写 你不写来试下哇
    pick.backgroundColor = [UIColor whiteColor];
    pick.delegate = self;
    pick.dataSource = self;
    //默认选中当前日期
    NSArray *arr = [Date componentsSeparatedByString:@"-"];
    NSInteger year = [arr[0] integerValue];
    NSInteger month = [arr[1] integerValue];
    NSInteger day = [arr[2] integerValue];
    
    [pick selectRow:year-1916 inComponent:0 animated:YES];
    [pick selectRow:month-1 inComponent:1 animated:YES];
    [pick selectRow:day-1 inComponent:2 animated:YES];
    
    self.title.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _yearArr.count;
    }else if (component == 1)
        return _monthArr.count;
    else
    {
        //日 |1、3、5、7、8、10、12 （31)| 2 (28/29)|4,6,9,11(30)
        NSInteger yearRow = [pickerView selectedRowInComponent:0];
        NSInteger monthRow = [pickerView selectedRowInComponent:1];
        //NSLog(@"%@",monthArr[monthRow]);
        //4,6,9,11
        if (monthRow == 3||monthRow == 5||monthRow == 8||monthRow == 10) {
            return 30;
        }
        else if(monthRow == 1)//2
        {
            NSInteger yearInt = [_yearArr[yearRow] integerValue];
            if (((yearInt%4==0)&&(yearInt%100!=0))||(yearInt%400==0))
            {
                return 29;
            }
            else
            {
                return 28;
            }
        }
        else
        {
            return 31;
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(pick.frame), BGHeight)];
    if (component == 0) {
        date.text = _yearArr[row];
    }else if (component == 1){
        date.text = _monthArr[row];
    }
    else{
        date.text = _dayArr[row];
    }
    date.textAlignment = NSTextAlignmentCenter;
    return date;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger yearRow = [pickerView selectedRowInComponent:0];
    NSInteger monthRow = [pickerView selectedRowInComponent:1];
    NSInteger dayRow = [pickerView selectedRowInComponent:2];
    NSString *year = _yearArr[yearRow];
    NSString *month = _monthArr[monthRow];
    NSString *day = _dayArr[dayRow];
    _title.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    [pickerView reloadAllComponents];
}
//toolbar按钮点击
- (void)btnClick:(UIButton *)sender
{
    [self.choseDelegate choseBtnClick:sender];
}
- (instancetype)initDatePickView
{
    if (self = [super init]) {
        [self setUpPickView];
    }
    return self;
}

- (void)showPickViewWhenClick:(UITextField *)textfield
{
    textfield.inputAccessoryView = bg;
    textfield.inputView = pick;
}
- (NSMutableArray *)yearArr
{
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
    }
    return _yearArr;
}
- (NSMutableArray *)monthArr
{
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
    }
    return _monthArr;
}
- (NSMutableArray *)dayArr
{
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
    }
    return _dayArr;
}
@end
