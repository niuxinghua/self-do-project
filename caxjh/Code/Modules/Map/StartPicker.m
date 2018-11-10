//
//  StartPicker.m
//  caxjh
//
//  Created by niuxinghua on 2018/1/18.
//  Copyright © 2018年 Yingchao Zou. All rights reserved.
//

#import "StartPicker.h"

@implementation StartPicker

static id startPicker = nil;
static dispatch_once_t onceToken;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!startPicker) {
        dispatch_once(&onceToken, ^{
            startPicker = [super instanceDatePickerView];
        });
    }
    return startPicker;
}
- (id)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        startPicker = [super init];
        
    }
                  );
    return startPicker;
}
+ (HZQDatePickerView *)sharedInstance {
    return [self instanceDatePickerView];
}
- (void)deleteSelf
{
    onceToken = 0;
    
}
@end
