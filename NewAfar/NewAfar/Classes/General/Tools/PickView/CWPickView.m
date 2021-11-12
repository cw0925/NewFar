//
//  CWPickView.m
//  AFarSoft
//
//  Created by 陈伟 on 16/8/8.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWPickView.h"

#define  ToolHeight 40
#define ViewW [UIScreen mainScreen].bounds.size.width
#define ViewH [UIScreen mainScreen].bounds.size.height

@interface CWPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
//@property(nonatomic,strong)UIPickerView *pickview;
@property(nonatomic,copy)NSArray *dataArr;
@property(nonatomic,assign)CGFloat pickH;
@end

@implementation CWPickView
{
    UIView *bg;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr=[[NSArray alloc] init];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpToolView];
    }
    return self;
}
- (instancetype)initPickViewWithArray:(NSArray *)arr
{
    if (self = [super init]) {
        self.dataArr = arr;
        [self setUpPickView];
        [self setFrameOfPickView];
    }
    return self;
}
- (void)setUpToolView
{
    //toolbar
    bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ToolHeight)];
    bg.backgroundColor = RGBColor(239, 240, 240);
    [self addSubview:bg];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 80, ToolHeight);
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:left];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(left.frame), 0, bg.frame.size.width-160, ToolHeight)];
    _title.textColor = RGBColor(75, 110, 216);
    _title.textAlignment = NSTextAlignmentCenter;
    [bg addSubview:_title];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(bg.frame.size.width - 80, 0, 80, ToolHeight);
    [right setTitle:@"确定" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:right];
}
//toolbar按钮点击
- (void)btnClick:(UIButton *)sender
{
    [self.senderDelegate senderClick:sender];
}
- (void)setFrameOfPickView
{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickH+ToolHeight;
    CGFloat toolViewY ;
    toolViewY = ViewH - toolViewH;
    self.frame = CGRectMake(toolViewX, toolViewY, ViewW, toolViewH);
}
- (void)setUpPickView
{
    UIPickerView *pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ToolHeight, ViewW, 216)];
    pick.backgroundColor = [UIColor whiteColor];
    _pickview = pick;
    pick.delegate = self;
    pick.dataSource = self;
    [self addSubview:pick];
    _pickH = pick.frame.size.height;
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewW, ToolHeight)];
    label.text = _dataArr[row];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _title.text = _dataArr[row];
}
- (void)showAt:(UIView *)view
{
    [view addSubview:self];
}
- (void)showAt:(UIView *)view whenClick:(UIButton *)sender
{
    [view addSubview:self];
}
-(void)remove
{
    [self removeFromSuperview];
}
@end
