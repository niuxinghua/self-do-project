//
//  UIActionSheet+Channel.m
//  Demo
//
//  Created by guofeixu on 15/11/5.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import "UIActionSheet+Channel.h"
#import <objc/runtime.h>

@implementation UIActionSheet (Channel)

static char channelKey;

- (void)setChannelArray:(NSArray *)aChannelArray{
    
    objc_setAssociatedObject(self, &channelKey, aChannelArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *) getChannelArray{
    
    return objc_getAssociatedObject(self, &channelKey);
}

@end
