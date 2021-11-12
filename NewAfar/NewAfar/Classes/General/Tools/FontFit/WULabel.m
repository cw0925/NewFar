//
//  XibLabel.m
//  FontFitDemo
//
//  Created by wuqh on 16/6/3.
//  Copyright © 2016年 吴启晗. All rights reserved.
//

#import "WULabel.h"
#import "UIFont+Fit.h"

@implementation WULabel

- (void)awakeFromNib {
    
    [self setFont:[UIFont systemFontWithSize:self.font.pointSize]];
}
@end
