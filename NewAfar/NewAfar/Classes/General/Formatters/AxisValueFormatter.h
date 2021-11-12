//
//  AxisValueFormatter.h
//  NewAfar
//
//  Created by kevin.chen on 2019/3/5.
//  Copyright © 2019 afarsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AxisValueFormatter : NSObject<IChartAxisValueFormatter>

@property(nonatomic,copy)NSArray *xArray;
- (instancetype)initForChart:(BarLineChartViewBase *)chart;

@end

NS_ASSUME_NONNULL_END
