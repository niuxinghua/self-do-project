//
//  NetWorkTool.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/4.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "NetWorkTool.h"
#import "AFNetworking.h"
static NetWorkTool *sharedInstance;

@interface NetWorkTool()

@property (nonatomic,assign)AFNetworkReachabilityStatus networkStatus;


@end
@implementation NetWorkTool

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc]init];
    });
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        sharedInstance.networkStatus = status;
        
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
        }else
        {
            
            
        }
    }];
    
    return sharedInstance;
    
}

- (BOOL)netWorkOK
{
    
    if(self.networkStatus ==AFNetworkReachabilityStatusReachableViaWWAN || self.networkStatus == AFNetworkReachabilityStatusReachableViaWiFi)
    {
        return YES;
    }
    
    return NO;
}
@end
