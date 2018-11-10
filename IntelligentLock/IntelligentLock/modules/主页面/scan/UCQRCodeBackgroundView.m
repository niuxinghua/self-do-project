//
//  UCQRCodeBackgroundView.m
//  WuRenJi
//
//  Created by Yingchao Zou on 23/11/2016.
//  Copyright © 2016 Casey. All rights reserved.
//

#import "UCQRCodeBackgroundView.h"

@implementation UCQRCodeBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0 blue:0 alpha:0.3];
    
    return self;
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[[UIColor blackColor] colorWithAlphaComponent:0.8] set];
//    CGContextFillRect(context, rect);
//}

@end
