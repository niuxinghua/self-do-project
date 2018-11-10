//
//  DBSlider.m
//  db_VideoPlayer
//
//  Created by 白色的黑豹 on 17/1/4.
//  Copyright © 2017年 杭州当贝网络科技有限公司. All rights reserved.
//

#import "DBSlider.h"

#define thumbBound_x 25
#define thumbBound_y 20

@interface DBSlider ()
{
    CGRect lastBounds;
}

@end

@implementation DBSlider


- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{

    rect.origin.x = rect.origin.x;
    if (rect.size.width < bounds.size.width - 2) {
        rect.size.width = rect.size.width + 2;
    }
   // rect.size.width = rect.size.width + 2;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    lastBounds = result;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
//    if ((point.y >= -thumbBound_y) && (point.y < lastBounds.size.height + thumbBound_y)) {
//        float value = 0.0;
//        value = point.x - self.bounds.origin.x;
//        value = value/self.bounds.size.width;
//
//        value = value < 0? 0 : value;
//        value = value > 1? 1: value;
//
//        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
//        [self setValue:value animated:YES];
//    }
    return result;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    
    return [super pointInside:point withEvent:event];
}

@end
