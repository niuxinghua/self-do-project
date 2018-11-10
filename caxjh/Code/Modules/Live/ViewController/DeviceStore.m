//
//  DeviceStore.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/25.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "DeviceStore.h"

@implementation DeviceStore
static id deviceStore = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!deviceStore) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            deviceStore = [super allocWithZone:zone];
        });
    }
    return deviceStore;
}
- (id)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceStore = [super init];
    });
    return deviceStore;
}
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}
@end
