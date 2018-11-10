//
//  LoginInfo.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LoginInfo.h"

@implementation LoginInfo
static LoginInfo *sharedModel;
+ (instancetype)sharedInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedModel) {
            sharedModel = [[LoginInfo alloc]init];
        }
    });
    
    return sharedModel;
    
    
}
@end
