//
//  PickView.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/2.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "PickView.h"

#define BGHeight 40

@interface PickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,copy)NSArray *dataArr;

@end

@implementation PickView
{
    UIView *bg;
    UIPickerView *pick;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
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
    pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bg.frame),216)];
    pick.backgroundColor = [UIColor whiteColor];
    pick.delegate = self;
    pick.dataSource = self;
    
    self.title.text = _dataArr[0];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArr.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(pick.frame), BGHeight)];
    title.text = _dataArr[row];
    title.textAlignment = NSTextAlignmentCenter;
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView reloadAllComponents];
    _title.text = _dataArr[row];
}
//toolbar按钮点击
- (void)btnClick:(UIButton *)sender
{
    //[self reloadAllComponents];
    [self.clickDelegate btnClick:sender];
}
- (instancetype)initPickViewWithArray:(NSArray *)array
{
    if (self = [super init]) {
        self.dataArr = array;
        [self setUpPickView];
    }
    return self;
}

- (void)showPickViewWhenClick:(UITextField *)textfield
{
    textfield.inputAccessoryView = bg;
    textfield.inputView = pick;
}
- (void)reloadData{
    [pick reloadAllComponents];
}
@end
