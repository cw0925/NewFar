//
//  PopView.m
//  PopView
//
//  Created by 陈伟 on 16/8/3.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "PopView.h"
#import "DXPopover.h"

@interface PopView ()

@property(nonatomic,copy)NSArray *dataArr;
@end

@implementation PopView
{
    DXPopover *pop;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (instancetype)initPopView
{
    if (self = [super init]) {
        pop = [DXPopover popover];
    }
    return self;
}
- (void)showPopViewWhenClick:(UIButton *)sender atView:(UIView *)view withArray:(NSArray *)arr
{
    
    self.dataArr = arr;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, arr.count*30) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 30;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    pop.contentInset = UIEdgeInsetsMake(20, 5.0, 20, 5.0);
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame) + 20);
    
    [pop showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:table
                       inView:view.window];
}
- (void)bounceTargetView:(UIView *)targetView {
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.itemDelegaate clickCell:indexPath.row];
}

- (void)remove
{
    [pop dismiss];
}
@end
