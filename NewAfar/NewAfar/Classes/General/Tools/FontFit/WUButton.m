//
//  XibButton.m
//  FontFitDemo
//
//  Created by wuqh on 16/6/3.
//  Copyright © 2016年 吴启晗. All rights reserved.
//

#import "WUButton.h"
#import "UIFont+Fit.h"

@implementation WUButton

- (void)awakeFromNib {
  
    self.titleLabel.font = [UIFont systemFontWithSize:self.titleLabel.font.pointSize];
}

@end
