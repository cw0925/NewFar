//
//  AxisValueFormatter.m
//  NewAfar
//
//  Created by kevin.chen on 2019/3/5.
//  Copyright © 2019 afarsoft. All rights reserved.
//

#import "AxisValueFormatter.h"

@implementation AxisValueFormatter
{
    __weak BarLineChartViewBase *_chart;
}

- (instancetype)initForChart:(BarLineChartViewBase *)chart
{
    self = [super init];
    if (self)
    {
        self->_chart = chart;
    }
    return self;
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    int days = (int)value;
    return self.xArray[days];
}
@end
