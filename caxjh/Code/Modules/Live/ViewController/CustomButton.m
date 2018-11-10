//
//  CustomButton.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/14.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event

{
    
    CGRect bounds = self.bounds;
    
    bounds = CGRectInset(bounds, -30, -30);
    
    return CGRectContainsPoint(bounds, point);
    
}

@end
