//
//  TimeSelectButton.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/27.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "TimeSelectButton.h"
#import "Masonry.h"
@implementation TimeSelectButton

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat width = self.frame.size.width * 5.0/6.0;
    CGFloat width1 = self.frame.size.width * 1.0/6.0;
    CGFloat height = self.frame.size.height;
    self.titleLabel.frame = CGRectMake(0, 0, width, height);
    self.imageView.frame = CGRectMake(width, (height-10)/2.0, 10, 10);
}

@end
