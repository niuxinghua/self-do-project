//
//  VerticalButton.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/29.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "VerticalButton.h"

@implementation VerticalButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(self.frame.size.width/6.0, 0, self.frame.size.width/3*2, self.frame.size.width/3*2);
    
    self.titleLabel.frame = CGRectMake(0,self.frame.size.height/3.0*2, self.frame.size.width, self.frame.size.height/3.0);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
