//
//  WUTextView.m
//  FontFitDemo
//
//  Created by wuqh on 16/6/4.
//  Copyright © 2016年 吴启晗. All rights reserved.
//

#import "WUTextView.h"
#import "UIFont+Fit.h"
@implementation WUTextView

- (void)awakeFromNib {
    [self setFont:[UIFont systemFontWithSize:self.font.pointSize]];
}

@end
