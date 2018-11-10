//
//  CityController.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/19.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "CityController.h"

@implementation CityController
static id sharedSDKManager = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!sharedSDKManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSDKManager = [super allocWithZone:zone];
        });
    }
    return sharedSDKManager;
}
- (id)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSDKManager = [super init];
    });
    _cityList = [[NSMutableArray alloc]init];
    return sharedSDKManager;
}
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}
- (void)getCity
{
    
    
}
@end
