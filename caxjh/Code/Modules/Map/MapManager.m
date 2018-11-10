//
//  MapManager.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/23.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MapManager.h"
#import "Const.h"
@interface MapManager()
{
    BMKMapManager* _mapManager;
}


@end
@implementation MapManager
static id mapManager = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!mapManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mapManager = [super allocWithZone:zone];
        });
    }
    return mapManager;
}
- (id)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapManager = [super init];
    });
    return mapManager;
}
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

- (void)initSDK
{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"4KXN6FbRcgS7UohdSaiM5foGOKxyxiU7"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
@end
