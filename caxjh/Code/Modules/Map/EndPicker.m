//
//  EndPicker.m
//  caxjh
//
//  Created by niuxinghua on 2018/1/18.
//  Copyright © 2018年 Yingchao Zou. All rights reserved.
//

#import "EndPicker.h"

@implementation EndPicker
static dispatch_once_t onceToken;
static id endPicker = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!endPicker) {
        dispatch_once(&onceToken, ^{
            endPicker = [super instanceDatePickerView];
        });
    }
    return endPicker;
}
- (id)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        endPicker = [super init];
        
    }
                  );
    return endPicker;
}
+ (HZQDatePickerView *)sharedInstance {
    return [self instanceDatePickerView];
}
- (void)deleteSelf
{
    onceToken = 0;
    
}
@end
